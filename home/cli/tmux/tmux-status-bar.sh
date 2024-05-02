#!/usr/bin/env bash
white="#96c7f1"
dim_1="#aaa8af"
dim_2="#5c6370"
black="#000000",
nocturne="#120d22"
azure="#0e1a60"
lavender="#b4befe"
peach="#fab387"

get() {
	local option=$1
	local default_value=$2
	local option_value
	option_value="$(tmux show-option -gqv "$option")"

	if [ "$option_value" = "" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}
gitmux_dir() {
	if [ -f "$HOME/.gitmux.conf" ]; then
		echo "$HOME/.gitmux.conf"
	elif [ -f "$HOME/.config/gitmux/gitmux.conf" ]; then
		echo "$HOME/.config/gitmux/gitmux.conf"
	else
		echo ""
	fi
}
get_os_logo() {
	declare -A os_logos
	os_logos["nixos"]=""
	os_logos["debian"]=""
	os_logos["ubuntu"]=""
	os_logos["fedora"]=""
	os_logos["archlinux"]=""
	os_logos["pop_os"]=""

	# Get the value of the ID from /etc/os-release
	os_id=$(grep ^ID /etc/os-release | cut -d= -f2)

	# Use the associative array to get the corresponding logo
	logo=${os_logos[$os_id]}
	if [ -z "$logo" ]; then
		logo=""
	fi

	# Echo the logo
	echo "$logo"
}

set() {
	local option=$1
	local value=$2
	tmux set-option -gq "$option" "$value"
}

setw() {
	local option=$1
	local value=$2
	tmux set-window-option -gq "$option" "$value"
}

set "status" "on"
set "status-justify" "left"
set "status-left-length" "100"
set "status-right-length" "100"
set "status-right-attr" "none"
set "message-fg" "$white"
set "message-bg" "$nocturne"
set "message-command-fg" "$white"
set "message-command-bg" "$nocturne"
set "status-attr" "none"
set "status-left-attr" "none"
setw "window-status-fg" "$nocturne"
setw "window-status-bg" "$nocturne"
setw "window-status-attr" "none"
setw "window-status-activity-bg" "$nocturne"
setw "window-status-activity-fg" "$nocturne"
setw "window-status-activity-attr" "none"
setw "window-status-separator" ""
set "window-style" "fg=$dim_2"
set "window-active-style" "fg=$white"
set "pane-border-fg" "$white"
set "pane-border-bg" "$nocturne"
set "pane-active-border-fg" "$lavender"
set "pane-active-border-bg" "$nocturne"
set "status-bg" "$nocturne"
set "status-fg" "$white"

prefix_status_color="#{?client_prefix,$peach,$lavender}"
sl_sep="#[fg=$nocturne,bg=$prefix_status_color,bold]"
set "status-left" "#[fg=$nocturne,bg=$prefix_status_color,bold]   #S #[bg=$prefix_status_color,bold]${sl_sep}"
gitmux="#(gitmux -cfg $(gitmux_dir) #{pane_current_path})"
git_status="#[fg=$white,bg=$azure,bold]${gitmux}#[fg=$white,bg=$azure,bold]"
os_name="#[fg=$azure,bg=$prefix_status_color,bold]$(get_os_logo)  $(grep ^NAME /etc/os-release | cut -d= -f2)"
sr_sep1="#[fg=$nocturne,bg=$azure,bold]"
sr_sep2="#[fg=$azure,bg=$prefix_status_color,bold]"
set "status-right" "${sr_sep1}#[fg=$white,bg=$azure] ${git_status} ${sr_sep2}#[fg=$azure,bg=$prefix_status_color,bold] ${os_name}  "
ws_sep1="#[bg=$black,fg=$nocturne,bold]"
ws_sep2="#[bg=$black,fg=$nocturne,bold]"
ws_index="#[fg=$dim_1,bg=$black,bold] #I #[fg=$dim_1,bg=$black,bold]"
ws_run="#[fg=$dim_1,bg=$black,bold] #W  "
set "window-status-format" "${ws_sep1}${ws_index}${ws_run}${ws_sep2}"
set "window-status-current-format" "#[bg=$azure,fg=$nocturne,bold]#[fg=$white,bg=$azure]#{?window_zoomed_flag,󰁌 ,}#[fg=$dim_1,bg=$azure]#{?window_zoomed_flag,,} #[fg=$white,bg=$azure]#W #[fg=$dim_1,bg=$azure,bold]#[fg=$white,bg=$azure,bold] #(basename #{pane_current_path}) #[bg=$azure,fg=$nocturne,bold]"
