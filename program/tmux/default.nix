{
  pkgs,
  config,
  ...
}: let
  resurrectDirPath = "${config.xdg.dataHome}/tmux/resurrect";
in {
  home.packages = with pkgs; [
    lsof
    gitmux
    # for tmux super fingers
    python311
  ];

  home.file.".gitmux.conf".source = ../../common/.gitmux.conf;

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    shell = "${pkgs.fish}/bin/fish";
    keyMode = "vi";
    sensibleOnTop = true;
    terminal = "tmux-256color";
    mouse = true;
    customPaneNavigationAndResize = true;
    disableConfirmationPrompt = true;
    prefix = "C-a";
    escapeTime = 0;
    historyLimit = 1000000;
    plugins = with pkgs.percygt.tmuxPlugins; [
      {
        plugin = tmuxinoicer;
        extraConfig = ''
          set -g @tmuxinoicer-find-base "/data:1:4"
          set -g @tmuxinoicer-extras "find"
        '';
      }
      {
        plugin = tmux-onedark-theme;
        extraConfig = "set -g status-position top";
      }
      {
        plugin = resurrect;
        extraConfig = ''
          # Taken from: https://github.com/p3t33/nixos_flake/blob/5a989e5af403b4efe296be6f39ffe6d5d440d6d6/home/modules/tmux.nix
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
      {
        plugin = tmux-thumbs;
        extraConfig = ''
          set -g @thumbs-command 'tmux set-buffer -- {} && tmux display-message "Copied {}" && printf %s {} | xclip -i -selection clipboard'
        '';
      }
      better-mouse-mode
      extrakto
      vim-tmux-navigator
      yank
      tmux-fzf
    ];
    extraConfig =
      /*
      bash
      */
      ''
        run-shell "if [ ! -d ${resurrectDirPath} ]; then tmux new-session -d -s main; ${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/scripts/save.sh; fi"

        # TERM override
        set terminal-overrides "xterm-256color:RGB"
        set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
        set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0
        set -g allow-passthrough on
        set -ga update-environment TERM
        set -ga update-environment TERM_PROGRAM
        set -g set-clipboard on
        set -g pane-active-border-style 'fg=magenta,bg=default'
        set -g pane-border-style 'fg=brightblack,bg=default'
        # make Prefix p paste the buffer.
        unbind p
        bind p paste-buffer

        # Copy mode using 'Esc'
        unbind [
        bind Escape copy-mode

        # Start selection with 'v' and copy using 'y'
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        set -g renumber-windows on       # renumber all windows when any window is closed
        bind-key X kill-session
        set-option -g detach-on-destroy off

        # Split
        unbind %
        unbind '"'
        bind s split-window -v -c "#{pane_current_path}"
        bind v split-window -h -c "#{pane_current_path}"
        bind-key g new-window 'lazygit; tmux kill-pane'

        # Easier move of windows
        bind-key -r Home swap-window -t - \; select-window -t -
        bind-key -r End swap-window -t + \; select-window -t +

        # switch to last session
        bind-key L switch-client -l

        # Pane to window
        unbind !
        bind-key w break-pane

        # Easier reload of config
        bind R source-file ~/.config/tmux/tmux.conf

        bind-key e send-keys "tmux capture-pane -p -S - | nvim -c 'set buftype=nofile' +" Enter
      '';
  };
}
