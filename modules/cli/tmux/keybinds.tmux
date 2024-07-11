# make Prefix p paste the buffer.
unbind p
bind p paste-buffer

# Copy mode using 'Esc'
unbind [
bind Escape copy-mode

# Start selection with 'v' and copy using 'y'
bind -T copy-mode-vi v send -X begin-selection
bind -T copy-mode-vi Escape send-keys -X cancel

# renumber all windows when any window is closed
set -g renumber-windows on
bind Delete kill-session
bind X kill-window -a
set-option -g detach-on-destroy off

# Split
unbind %
unbind '"'
bind s split-window -vc '#{pane_current_path}'
bind v split-window -hc '#{pane_current_path}'

# window navigation
unbind n
unbind [
bind l next
bind h prev
bind Space last-window
bind b switchc -l

# tui's
unbind d
unbind f
unbind g
bind g new-window 'lazygit; tmux kill-pane'
bind d new-window 'lazydocker; tmux kill-pane'
bind f new-window 'yazi; tmux kill-pane'

# Resize window
bind -n M-H resize-pane -L 2
bind -n M-L resize-pane -R 2
bind -n M-K resize-pane -U 2
bind -n M-J resize-pane -D 2
# Easier move of windows
bind -r Home swap-window -t - \; select-window -t -
bind -r End swap-window -t + \; select-window -t +

# Pane to window
unbind !
bind w break-pane

# Easier reload of config
bind R source-file ~/.config/tmux/tmux.conf

# shell display to nvim
bind e send-keys 'tmux capture-pane -p -S - | nvim -c "set buftype=nofile" +' Enter
