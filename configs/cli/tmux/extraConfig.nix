{
  pkgs,
  config,
  username,
  ...
}:
let
  resurrectDirPath = "${config.xdg.dataHome}/tmux/resurrect";
  resurrectPostSave = pkgs.writers.writeBash "resurrectPostSave" ''
    sed -E '/^pane/s|:/nix/store/[^ ]+/bin/nvim.*loaded_ruby_provider=0|:nvim|g' -i "$1"
    sed -i '/^pane/s|:/home/${username}/.local/state/nix/profile/bin/||g' "$1"
    sed -i '/~\/.*>/s|>||g' "$1"
    sed -i 's|fish	:\[fish\] <defunct>|fish	:|g' "$1"
    sed -i ':a;N;$!ba;s|\[fish\] <defunct>\n||g' "$1"
  '';
  tp = pkgs.stable.tmuxPlugins;
in
{
  programs.tmux.extraConfig =
    # tmux
    ''
      # ---------------------
      # Config before plugins
      # ---------------------
      source ${config.xdg.configHome}/tmux/variables.conf
      source ${config.xdg.configHome}/tmux/beforePlugins.conf

      # ============================================= #
      # Load plugins with Home Manager                #
      # ============================================= #


      # ---------------------
      # tmuxplugin-resurrect
      # ---------------------
      set -g @resurrect-capture-pane-contents 'on'
      set -g @resurrect-processes 'nvim'
      set -g @resurrect-dir '${resurrectDirPath}'
      set -g @resurrect-hook-post-save-all '${resurrectPostSave} "${resurrectDirPath}/last"'
      run-shell ${tp.resurrect}/share/tmux-plugins/resurrect/resurrect.tmux



      # ---------------------
      # tmuxplugin-tmuxinoicer
      # ---------------------

      set -g @tmuxinoicer-find-base "${config.home.homeDirectory}/data:1:4,${config.home.homeDirectory}:1:1"
      set -g @tmuxinoicer-extras "find"
      unbind ,
      set -g @tmuxinoicer-bind ","
      run-shell ${tp.tmuxinoicer}/share/tmux-plugins/tmuxinoicer/tmuxinoicer.tmux


      # ---------------------
      # tmuxplugin-vim-tmux-navigator
      # ---------------------
      run-shell ${tp.vim-tmux-navigator}/share/tmux-plugins/vim-tmux-navigator/vim-tmux-navigator.tmux

      # ---------------------
      # tmuxplugin-yank
      # ---------------------

      run-shell ${pkgs.tmuxPlugins.yank}/share/tmux-plugins/yank/yank.tmux

      # ---------------------
      # tmuxplugin-extrakto
      # ---------------------
      set -g @extrakto_clip_tool 'wl-copy'
      run-shell ${tp.extrakto}/share/tmux-plugins/extrakto/extrakto.tmux

      # ---------------------
      # tmuxplugin-continuum
      # ---------------------
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '10'
      # set -g @continuum-boot 'on'
      # set -g @continuum-systemd-start-cmd 'start-server'
      run-shell ${tp.continuum}/share/tmux-plugins/continuum/continuum.tmux


      # ---------------------
      # Config after plugins
      # ---------------------
      source ${config.xdg.configHome}/tmux/afterPlugins.conf
    '';
}
