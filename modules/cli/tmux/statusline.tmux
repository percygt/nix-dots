# Status line customisation
set -g status-left-length 200
set -g status-left-style 'fg=#{?client_prefix,colour63,colour255},bold'
set -g status-left ' #{session_name}  '
set -g status-right ' #(gitmux -cfg $HOME/.config/gitmux/gitmux.yaml #{pane_current_path}) '
set -g status-style 'bg=default'

set -g window-status-format '#{window_index}:#{window_name}#{window_flags} '
set -g window-status-current-format '#{window_index}:#{window_name}#{window_flags} '
set -g window-status-current-style 'fg=colour11,bold'
set -g window-status-last-style 'fg=colour1'
set -g window-status-activity-style none
