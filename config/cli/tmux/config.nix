{ pkgs, config }:
let
  resurrectDirPath = "${config.xdg.dataHome}/tmux/resurrect";
  resurrectPostSave = pkgs.writers.writeBash "resurrectPostSave" ''
    sed -i -E "s|(pane.*nvim\s*:)[^;]+;.*\s([^ ]+)$|\1nvim|" "$1"
    sed -ie "s|:bash .*/tmp/nix-shell-.*/rc|:nix-shell|g" "$1"
    sed -i "s| $HOME| ~|g" "$1"
    sed -i 's|fish	:\[fish\] <defunct>|fish	:|g' "$1"
    sed -i ':a;N;$!ba;s|\[fish\] <defunct>\n||g' "$1"
  '';
in
{
  extraConfig =
    # tmux
    ''
      # Config before plugins
      # ---------------------
      source ${config.xdg.configHome}/tmux/variables.conf
      source ${config.xdg.configHome}/tmux/beforePlugins.conf

      # ============================================= #
      # Load plugins with Home Manager                #
      # --------------------------------------------- #

      # tmuxplugin-tmuxinoicer
      # ---------------------
      set -g @tmuxinoicer-find-base "${config.home.homeDirectory}/data:1:4,${config.home.homeDirectory}:1:1"
      set -g @tmuxinoicer-extras "find"

      run-shell ${pkgs.tmuxPlugins.tmuxinoicer}/share/tmux-plugins/tmuxinoicer/tmuxinoicer.tmux


      # tmuxplugin-tmux-thumbs
      # ---------------------
      set -g @thumbs-command 'tmux set-buffer -- {} && tmux display-message "Copied {}" && printf %s {} | xclip -i -selection clipboard'

      run-shell ${pkgs.tmuxPlugins.tmux-thumbs}/share/tmux-plugins/tmux-thumbs/tmux-thumbs.tmux


      # tmuxplugin-better-mouse-mode
      # ---------------------

      run-shell ${pkgs.tmuxPlugins.better-mouse-mode}/share/tmux-plugins/better-mouse-mode/scroll_copy_mode.tmux


      # tmuxplugin-extrakto
      # ---------------------

      run-shell ${pkgs.tmuxPlugins.extrakto}/share/tmux-plugins/extrakto/extrakto.tmux


      # tmuxplugin-vim-tmux-navigator
      # ---------------------

      run-shell ${pkgs.tmuxPlugins.vim-tmux-navigator}/share/tmux-plugins/vim-tmux-navigator/vim-tmux-navigator.tmux


      # tmuxplugin-yank
      # ---------------------

      run-shell ${pkgs.tmuxPlugins.yank}/share/tmux-plugins/yank/yank.tmux


      # tmuxplugin-resurrect
      # ---------------------
      set -g @resurrect-capture-pane-contents 'on'
      set -g @resurrect-dir '${resurrectDirPath}'
      set -g @resurrect-hook-post-save-all '${resurrectPostSave} "${resurrectDirPath}/last"'

      run-shell ${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/resurrect.tmux


      # tmuxplugin-continuum
      # ---------------------
      set -g @continuum-restore 'on'
      # set -g @continuum-boot 'on'
      set -g @continuum-save-interval '10'
      # set -g @continuum-systemd-start-cmd 'start-server'

      run-shell ${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum/continuum.tmux


      # Config after plugins
      # ---------------------
      source ${config.xdg.configHome}/tmux/afterPlugins.conf
    '';
}
