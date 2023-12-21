{pkgs, ...}: {
  home.packages = [
    pkgs.gitmux
  ];
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    keyMode = "vi";
    terminal = "tmux-256color";
    mouse = true;
    prefix = "C-a";
    escapeTime = 0;
    historyLimit = 1000000;
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = continuum;
        extraConfig = "set -g @continuum-restore 'on'";
      }
      {
        plugin = power-theme.overrideAttrs (_: {
          src = pkgs.fetchFromGitHub {
            owner = "percygt";
            repo = "tmux-power";
            rev = "2ebd36bd88a82c32b699dc972b59b4984b586094";
            hash = "sha256-VBLTFbEAga2/gq2AEXF0kEo0pHHEynj1GrbEY6+CTXM=";
          };
        });
        extraConfig = ''
          set -g @tmux_power_theme "default"
          # set -g @tmux_power_right_arrow_icon ""
          # set -g @tmux_power_left_arrow_icon ""
          set -g status-position top
        '';
      }
      {
        plugin = fzf-tmux-url;
        extraConfig = ''
          set -g @fzf-url-fzf-options '-p 60%,30% --prompt="   " --border-label=" Open URL "'
          set -g @fzf-url-history-limit '2000'
        '';
      }
      sensible
      yank
      tmux-thumbs
      tmux-fzf
    ];
    extraConfig = ''
      # TERM override
      set terminal-overrides "xterm*:RGB"
      set -g set-clipboard on

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Copy mode using 'Esc'
      unbind [
      bind Escape copy-mode

      # Start selection with 'v' and copy using 'y'
      bind-key -T copy-mode-vi v send-keys -X begin-selection

    '';
  };
}
