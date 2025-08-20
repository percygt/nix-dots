#!/usr/bin/env bash

APP_ID=""
TITLE=""
COMMAND=()

while [[ $# -gt 0 ]]; do
	case "$1" in
	--app-id)
		APP_ID="$2"
		shift 2
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

if [[ -z $APP_ID ]]; then
	echo "Error: --app-id is required."
	exit 1
fi

if [[ ${#COMMAND[@]} -gt 0 ]]; then
	WINDOW_ID=$(niri msg --json windows | jq -r ".[] | select(.app_id==\"$APP_ID\") | .id")
	if [ -n "$WINDOW_ID" ]; then
		niri msg action focus-window --id "$WINDOW_ID"
		niri msg action close-window
	else
		footclient --app-id="$APP_ID" --title="$TITLE" -- "${COMMAND[@]}"
	fi
else
	echo "No command provided after '--'."
fi
