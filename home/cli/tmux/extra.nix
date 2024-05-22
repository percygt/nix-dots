{pkgs}: {
  extraConfig =
    /*
    bash
    */
    ''
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

      # renumber all windows when any window is closed
      set -g renumber-windows on

      bind-key Delete kill-session
      bind-key X kill-window -a
      set-option -g detach-on-destroy off

      # Split
      unbind %
      unbind '"'
      bind s split-window -v -c "#{pane_current_path}"
      bind v split-window -h -c "#{pane_current_path}"

      # window navigation
      unbind n
      unbind [
      bind l next
      bind h prev

      # tui's
      unbind d
      unbind f
      unbind g
      unbind K
      unbind k
      bind-key g new-window 'lazygit; tmux kill-pane'
      bind-key d new-window 'lazydocker; tmux kill-pane'
      bind-key f new-window 'yazi; tmux kill-pane'
      bind-key K new-window 'kpass; tmux kill-pane'
      bind k send-keys -t.- 'pmenu' Enter

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

      # shell display to nvim
      bind-key e send-keys "tmux capture-pane -p -S - | nvim -c 'set buftype=nofile' +" Enter
    '';
}
