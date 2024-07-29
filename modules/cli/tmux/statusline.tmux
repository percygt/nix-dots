#!/usr/bin/env bash
getGitmuxDir() {
	if [ -f "$HOME/.gitmux.yaml" ]; then
		echo "$HOME/.gitmux.yaml"
	elif [ -f "$HOME/.config/tmux/gitmux.yaml" ]; then
		echo "$HOME/.config/tmux/gitmux.yaml"
	else
		echo ""
	fi
}
gitmuxDir=$(getGitmuxDir)

gitmux="#(gitmux -cfg ${gitmuxDir} #{pane_current_path})"

# Status line customisation
tmux set-option -g status-justify centre
tmux set-option -g status-left-length 90
tmux set-option -g status-right-length 90
tmux set-option -g status-right-style "fg=#{?client_prefix,#{@FG_PREFIX_ACTIVE},#{@FG_PREFIX}}"
tmux set-option -g status-right " ${gitmux} "
tmux set-option -g status-style "fg=#{@FG_STATUS},bg=default"
tmux set-option -g window-status-current-style "fg=#{?client_prefix,#{@FG_PREFIX_ACTIVE},#{@FG_WINDOW_ACTIVE}}"
tmux set-option -g window-status-last-style "fg=#{@FG_WINDOW_PREV}"
tmux set-option -g window-status-format "#[italics]#I: #[noitalics]#W "
tmux set-option -g window-status-current-format "#[bold,italics]#I: #[noitalics]#W#{window_flags} "
tmux set-option -g window-status-activity-style none
