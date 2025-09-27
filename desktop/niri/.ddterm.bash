#!/usr/bin/env bash
APP_ID=""
COMMAND=()

while [[ $# -gt 0 ]]; do
	case "$1" in
	--app-id=*)
		APP_ID="''${1#*=}"
		shift
		;;
	--app-id)
		APP_ID="$2"
		shift 2
		;;
	--)
		shift
		COMMAND=("$@")
		break
		;;
	*)
		echo "Unknown option: $1"
		exit 1
		;;
	esac
done

if [[ -z $APP_ID ]]; then
	echo "Error: Provide app_id parameter"
	exit 1
fi

WORKSPACE_ID=$(niri msg -j workspaces | jq '.[] | select(.is_focused == true) | .idx')
FOCUSED_APP_ID=$(niri msg -j windows | jq '.[] | select(.is_focused == true) | .id')

if [[ ${#COMMAND[@]} -gt 0 ]]; then
	WINDOW_ID=$(niri msg -j windows | jq -r ".[] | select(.app_id==\"$APP_ID\") | .id")
	if [ -n "$WINDOW_ID" ]; then
		if [ "$FOCUSED_APP_ID" == "$WINDOW_ID" ]; then
			niri msg action move-window-to-floating --id "$WINDOW_ID"
			niri msg action focus-window-previous
			niri msg action set-window-width --id "$WINDOW_ID" 0
			niri msg action set-window-height --id "$WINDOW_ID" 0
			niri msg action move-floating-window --id "$WINDOW_ID" -x 0 -y 0
		else
			niri msg action move-window-to-floating --id "$WINDOW_ID"
			niri msg action move-window-to-workspace --window-id "$WINDOW_ID" "$WORKSPACE_ID"
			niri msg action focus-window --id "$WINDOW_ID"
			niri msg action move-floating-window -x 31 -y 16
			niri msg action set-window-height --id "$WINDOW_ID" 720
			niri msg action set-window-width --id "$WINDOW_ID" 1000
		fi
	else
		"${COMMAND[@]}"
	fi
else
	echo "No command provided after '--'."
fi
