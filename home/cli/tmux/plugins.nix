{
  pkgs,
  config,
  ...
}: let
  resurrectDirPath = "${config.xdg.dataHome}/tmux/resurrect";
  resurrectPostSave = pkgs.writers.writeBash "resurrectPostSave" ''
    sed -ie "s| --cmd .*-vim-pack-dir||g" "$1"
    sed -ie "s|nvim --cmd.*ruby.|nvim|g" "$1"
    sed -ie "s|/etc/profiles/per-user/$USER/bin/||g" "$1"
    sed -ie "s|/home/$USER/.nix-profile/bin/||g" "$1"
    sed -i 's|fish	:\[fish\] <defunct>|fish	:|g' "$1"
    sed -i ':a;N;$!ba;s|\[fish\] <defunct>\n||g' "$1"
    sed -i "s|/run/current-system/sw/bin/||g" "$1"
    sed -i "s| $HOME| ~|g" "$1"
    sed -ie "s|:bash .*/tmp/nix-shell-.*/rc|:nix-shell|g" "$1"
  '';
in {
  plugins = with pkgs.stash.tmuxPlugins; [
    {
      plugin = tmuxinoicer;
      extraConfig = ''
        set -g @tmuxinoicer-find-base "${config.home.homeDirectory}/data:1:4,${config.home.homeDirectory}:1:1"
        set -g @tmuxinoicer-extras "find"
      '';
    }
    {
      plugin = tmux-thumbs;
      extraConfig = ''
        set -g @thumbs-command 'tmux set-buffer -- {} && tmux display-message "Copied {}" && printf %s {} | xclip -i -selection clipboard'
      '';
    }
    {
      plugin = fzf-url;
      extraConfig = ''
        set -g @fzf-url-fzf-options '-h 50% --multi -0 --no-preview'
      '';
    }
    better-mouse-mode
    extrakto
    vim-tmux-navigator
    yank
    tmux-fzf
    {
      plugin = resurrect;
      extraConfig = ''
        set -g @resurrect-processes '"~nvim"'
        set -g @resurrect-capture-pane-contents 'on'
        set -g @resurrect-dir ${resurrectDirPath}
        set -g @resurrect-hook-post-save-all '${resurrectPostSave} "${resurrectDirPath}/last"'
      '';
    }
    {
      plugin = continuum;
      extraConfig = ''
        set -g @continuum-restore 'on'
        set -g @continuum-boot 'on'
        set -g @continuum-save-interval '10'
        set -g @continuum-systemd-start-cmd 'start-server'
      '';
    }
  ];
}
