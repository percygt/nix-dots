#!/usr/bin/env bash
APP_ID=""
TERM=""
TITLE=""
COMMAND=()

while [[ $# -gt 0 ]]; do
	case "$1" in
	--term=*)
		TERM="${1#*=}"
		shift
		;;
	--term)
		TERM="$2"
		shift 2
		;;
	--app-id=*)
		APP_ID="${1#*=}"
		shift
		;;
	--app-id)
		APP_ID="$2"
		shift 2
		;;
	--title=*)
		TITLE="${1#*=}"
		shift
		;;
	--title)
		TITLE="$2"
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

FOOT_OPTS=(--app-id="$APP_ID")
if [[ -n $TERM ]]; then
	FOOT_OPTS+=(--term="$TERM")
fi
if [[ -n $TITLE ]]; then
	FOOT_OPTS+=(--title="$TITLE")
fi
if [[ -z $APP_ID ]]; then
	echo "Error: Provide app_id parameter"
	exit 1
fi

WORKSPACE_ID=$(niri msg -j workspaces | jq ".[] | select(.is_focused == true) | .idx")
FOCUSED_APP_ID=$(niri msg -j windows | jq ".[] | select(.is_focused == true) | .id")

if [[ ${#COMMAND[@]} -gt 0 ]]; then
	APP=$(niri msg -j windows | jq ".[] | select(.app_id==\"$APP_ID\")")
	WINDOW_ID=$(echo "$APP" | jq ".id")
	WINDOW_SIZE=$(echo "$APP" | jq ".layout.window_size.[0]")
	if [ -n "$WINDOW_ID" ]; then
		if [ "$FOCUSED_APP_ID" == "$WINDOW_ID" ] || [[ $WINDOW_SIZE -gt 40 ]]; then
			niri msg action move-window-to-floating --id "$WINDOW_ID"
			niri msg action focus-window-previous
			niri msg action set-window-width --id "$WINDOW_ID" 0
			niri msg action set-window-height --id "$WINDOW_ID" 0
			niri msg action move-floating-window --id "$WINDOW_ID" -x 0 -y 0
		else
			niri msg action move-window-to-floating --id "$WINDOW_ID"
			niri msg action move-window-to-workspace --window-id "$WINDOW_ID" "$WORKSPACE_ID"
			niri msg action focus-window --id "$WINDOW_ID"
			niri msg action move-floating-window -x 0 -y 0
			niri msg action set-window-height --id "$WINDOW_ID" 100%
			niri msg action set-window-width --id "$WINDOW_ID" 100%
		fi
	else
		exec footclient "${FOOT_OPTS[@]}" -- "${COMMAND[@]}"
	fi
else
	echo "No command provided after '--'."
fi
