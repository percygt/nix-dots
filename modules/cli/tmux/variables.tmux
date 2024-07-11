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
# Allow tmux to set the terminal title
set -g set-titles on
# Monitor window activity to display in the status bar
setw -g monitor-activity on
# A bell in another window should cause a bell in the current window
# set -g bell-action any
# Don't show distracting notifications
set -g visual-bell off
set -g visual-activity off
# Focus events enabled for terminals that support them
set -g focus-events on
# don't detach tmux when killing a session
set -g detach-on-destroy off
