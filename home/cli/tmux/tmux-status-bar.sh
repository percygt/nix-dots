#!/usr/bin/env bash
get_tmux_option() {
	local option=$1
	local default_value=$2
	local option_value

	option_value=$(tmux show -gqv "$option")
	echo "${option_value:-$default_value}"
}

handle_tmux_option() {
	WHITE=$(get_tmux_option "@color1" "#96c7f1")
	GREY=$(get_tmux_option "@color2" "#aaa8af")
	BLACK=$(get_tmux_option "@color3" "#000000")
	NOCTURNE=$(get_tmux_option "@color4" "#120d22")
	AZURE=$(get_tmux_option "@color5" "#0e1a60")
	LAVENDER=$(get_tmux_option "@color6" "#b4befe")
	PEACH=$(get_tmux_option "@color7" "#fab387")
}
handle_tmux_option

getGitmuxDir() {
	if [ -f "$HOME/.gitmux.conf" ]; then
		echo "$HOME/.gitmux.conf"
	elif [ -f "$HOME/.config/gitmux/gitmux.conf" ]; then
		echo "$HOME/.config/gitmux/gitmux.conf"
	else
		echo ""
	fi
}

getOsLogo() {
	declare -A os_logos
	os_logos["nixos"]=""
	os_logos["debian"]=""
	os_logos["ubuntu"]=""
	os_logos["fedora"]=""
	os_logos["archlinux"]=""
	os_logos["pop_os"]=""
	os_id=$(grep ^ID /etc/os-release | cut -d= -f2)
	logo=${os_logos[$os_id]}
	if [ -z "$logo" ]; then
		logo=""
	fi
	echo "$logo"
}

gitmuxDir=$(getGitmuxDir)
osName=$(grep ^NAME /etc/os-release | cut -d= -f2)

setWinOpt() {
	local option=$1
	local value=$2
	tmux set-window-option -gq "$option" "$value"
}

setOpt() {
	local option=$1
	local value=$2
	tmux set-option -gq "$option" "$value"
}

handle_tmux_option

setWinOpt "window-status-fg" "$NOCTURNE"
setWinOpt "window-status-bg" "$NOCTURNE"
setWinOpt "window-status-attr" "none"
setWinOpt "window-status-activity-bg" "$NOCTURNE"
setWinOpt "window-status-activity-fg" "$NOCTURNE"
setWinOpt "window-status-activity-attr" "none"
setWinOpt "window-status-separator" ""
setOpt "status" "on"
setOpt "status-justify" "left"
setOpt "status-left-length" "100"
setOpt "status-right-length" "100"
setOpt "status-right-attr" "none"
setOpt "message-fg" "$WHITE"
setOpt "message-bg" "$NOCTURNE"
setOpt "message-command-fg" "$WHITE"
setOpt "message-command-bg" "$NOCTURNE"
setOpt "status-attr" "none"
setOpt "status-left-attr" "none"
setOpt "window-style" "fg=$GREY"
setOpt "window-active-style" "fg=$WHITE"
setOpt "pane-border-fg" "$WHITE"
setOpt "pane-border-bg" "$NOCTURNE"
setOpt "pane-active-border-fg" "$LAVENDER"
setOpt "pane-active-border-bg" "$NOCTURNE"
setOpt "status-bg" "$NOCTURNE"
setOpt "status-fg" "$WHITE"

prefixStatus="#{?client_prefix,$PEACH,$LAVENDER}"
stLfSeparator="#[fg=$NOCTURNE,bg=$prefixStatus,bold]"
stLfSession="#[fg=$NOCTURNE,bg=$prefixStatus,bold]   #S #[bg=$prefixStatus,bold]"
gitmux="#(gitmux -cfg ${gitmuxDir} #{pane_current_path})"
stRtGitStatus="#[fg=$WHITE,bg=$AZURE] #[fg=$WHITE,bg=$AZURE,bold]${gitmux}#[fg=$WHITE,bg=$AZURE,bold] "
stRtLinuxName="#[fg=$AZURE,bg=$prefixStatus,bold] #[fg=$AZURE,bg=$prefixStatus,bold]$(getOsLogo)  ${osName}  "
stRtSeparator1="#[fg=$NOCTURNE,bg=$AZURE,bold]"
stRtSeparator2="#[fg=$AZURE,bg=$prefixStatus,bold]"
winStSeparator1="#[bg=$BLACK,fg=$NOCTURNE,bold]"
winStSeparator2="#[bg=$BLACK,fg=$NOCTURNE,bold]"
winStIndex="#[fg=$GREY,bg=$BLACK,bold] #I #[fg=$GREY,bg=$BLACK,bold]"
winStRunningProg="#[fg=$GREY,bg=$BLACK,bold] #W  "
winStCurSeparator1="#[bg=$AZURE,fg=$NOCTURNE,bold]"
winStCurSeparator2="#[bg=$AZURE,fg=$NOCTURNE,bold]"
winStCurZoom="#[fg=$WHITE,bg=$AZURE]#{?window_zoomed_flag, 󰁌 ,}#[fg=$GREY,bg=$AZURE]#{?window_zoomed_flag,,} "
winStCurRunningProg="#[fg=$WHITE,bg=$AZURE]#W #[fg=$GREY,bg=$AZURE,bold]"
winStCurPath="#[fg=$WHITE,bg=$AZURE,bold] #(basename #{pane_current_path}) "

setOpt "status-right" "${stRtSeparator1}${stRtGitStatus}${stRtSeparator2}${stRtLinuxName}"
setOpt "status-left" "${stLfSession}${stLfSeparator}"
setOpt "window-status-format" "${winStSeparator1}${winStIndex}${winStRunningProg}${winStSeparator2}"
setOpt "window-status-current-format" "${winStCurSeparator1}${winStCurZoom}${winStCurRunningProg}${winStCurPath}${winStCurSeparator2}"
