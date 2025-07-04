{
  pkgs,
  config,
  username,
  homeDirectory,
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
  g = config._base;
  tp = pkgs.tmuxPlugins;
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
      run-shell "${pkgs.tmuxPlugins.resurrect.rtp}"

      # ---------------------
      # tmuxplugin-tmux-switcher
      # ---------------------

      set -g @tmux-switcher-find-base "${g.dataDirectory}:1:4,${homeDirectory}:1:1"
      set -g @tmux-switcher-extras "find"
      unbind ,
      set -g @tmux-switcher-bind ","
      run-shell "${tp.tmux-switcher.rtp}"


      # ---------------------
      # tmuxplugin-vim-tmux-navigator
      # ---------------------
      run-shell "${tp.vim-tmux-navigator.rtp}"


      # ---------------------
      # tmuxplugin-yank
      # ---------------------

      run-shell "${tp.yank.rtp}"

      # ---------------------
      # tmuxplugin-extrakto
      # ---------------------
      set -g @extrakto_clip_tool 'wl-copy'
      run-shell "${tp.extrakto.rtp}"

      # ---------------------
      # tmuxplugin-continuum
      # ---------------------
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '10'
      run-shell "${tp.continuum.rtp}"


      # ---------------------
      # Config after plugins
      # ---------------------
      source ${config.xdg.configHome}/tmux/afterPlugins.conf
    '';
}
