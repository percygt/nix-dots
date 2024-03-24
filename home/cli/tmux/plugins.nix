{
  pkgs,
  config,
  ...
}: let
  resurrectDirPath = "${config.xdg.dataHome}/tmux/resurrect";
in {
  plugins = with pkgs.stash.tmuxPlugins; [
    {
      plugin = tmuxinoicer;
      extraConfig = ''
        set -g @tmuxinoicer-find-base "${config.home.homeDirectory}/data:1:4,${config.xdg.configHome}/home-manager,${config.home.homeDirectory}/nix-dots"
        set -g @tmuxinoicer-extras "find"
      '';
    }
    {
      plugin = tmux-onedark-theme;
      extraConfig = "set -g status-position top";
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
        set -g @resurrect-strategy-vim 'session'
        set -g @resurrect-strategy-nvim 'session'
        set -g @resurrect-capture-pane-contents 'on'
        set -g @resurrect-dir ${resurrectDirPath}
        set -g @resurrect-hook-post-save-all 'target=$(readlink -f ${resurrectDirPath}/last); sed "s| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g; s|/home/$USER/.nix-profile/bin/||g" $target | sponge $target'
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
