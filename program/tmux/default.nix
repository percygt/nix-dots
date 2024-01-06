{
  pkgs,
  config,
  ...
}: let
  resurrectDirPath = "${config.xdg.dataHome}/tmux/resurrect";
  t-smart-manager = pkgs.tmuxPlugins.mkTmuxPlugin rec {
    pluginName = "t-smart-tmux-session-manager";
    version = "v2.8.0";
    rtpFilePath = "t-smart-tmux-session-manager.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "joshmedeski";
      repo = "t-smart-tmux-session-manager";
      rev = version;
      sha256 = "sha256-EMDEEIWJ+XFOk0WsQPAwj9BFBVDNwFUCyd1ScceqKpc=";
    };
  };
  sessionx = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-sessionx";
    version = "unstable-2024-01-01";
    rtpFilePath = "sessionx.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "omerxx";
      repo = "tmux-sessionx";
      rev = "847cf28c836da1219e039cb7c4379a2c314a8a04";
      hash = "sha256-cAh0S88pMlWBv5rEB11+jAxv/8fT/DGiO8eeFLFxQ/g=";
    };
    postInstall = ''
      sed -i -e 's|z_target=$(zoxide query "$target")|z_target=$(${pkgs.zoxide}/bin/zoxide query "$target")|g' $target/scripts/sessionx.sh
      sed -i -e 's|''${TMUX_PLUGIN_MANAGER_PATH%/}/tmux-sessionx/scripts/preview.sh|${placeholder "out"}/share/tmux-plugins/tmux-sessionx/scripts/preview.sh|g' $target/scripts/sessionx.sh
    '';
  };
in {
  home.packages = with pkgs; [
    lsof
    gitmux
    # for tmux super fingers
    python311
  ];

  home.file.".gitmux.conf".source = ../../common/.gitmux.conf;

  programs.fish.shellInit = ''
    fish_add_path ${t-smart-manager}/share/tmux-plugins/t-smart-tmux-session-manager/bin/
    fish_add_path ${sessionx}/share/tmux-plugins/tmux-sessionx/bin/
  '';

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
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = t-smart-manager;
        extraConfig = ''
          set -g @t-fzf-prompt '  '
          set -g @t-bind "T"
        '';
      }
      {
        plugin = sessionx;
        extraConfig = ''
          set -g @sessionx-bind "o"
          set -g @sessionx-window-height "60%"
          set -g @sessionx-window-width "90%"
          set -g @sessionx-preview-location 'right'
          set -g @sessionx-preview-ratio '55%'
          set -g @sessionx-zoxide-mode "on"
          set -g @session_path "/data/git-repo/github.com/"
        '';
      }
      {
        plugin = onedark-theme.overrideAttrs (_: {
          src = pkgs.fetchFromGitHub {
            owner = "percygt";
            repo = "tmux-onedark-theme";
            rev = "189bc3ee34b9bf71b2ebd6d5fed7bc37afc2bc76";
            hash = "sha256-l/AMWYMwkq4gHEzeHdNJ5g3S7BR0EywLXERFt+Bwe6c=";
          };
        });
        extraConfig = "set -g status-position top";
      }
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-strategy-vim 'session'
          # Taken from: https://github.com/p3t33/nixos_flake/blob/5a989e5af403b4efe296be6f39ffe6d5d440d6d6/home/modules/tmux.nix
          set -g @resurrect-capture-pane-contents 'on'

          set -g @resurrect-dir ${resurrectDirPath}
          set -g @resurrect-hook-post-save-all 'target=$(readlink -f ${resurrectDirPath}/last); sed "s| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g" $target | sponge $target'
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
    extraConfig = ''
      run-shell "if [ ! -d ~/.config/tmux/resurrect ]; then tmux new-session -d -s init-resurrect; ${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/scripts/save.sh; fi"
      set-environment -g TMUX_PLUGIN_MANAGER_PATH '~/.local/share/tmux/plugins'
      # TERM override
      set terminal-overrides "xterm-256color:RGB"
      set -g set-clipboard on

      # make Prefix p paste the buffer.
      unbind p
      bind p paste-buffer

      set -g allow-passthrough on
      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM

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
      bind r source-file ~/.config/tmux/tmux.conf
    '';
  };
}
