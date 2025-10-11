#!/usr/bin/env bash
APP_ID=""
TERM=""
TITLE=""
COMMAND=()

pgrep -x foot || foot --server &

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

if [[ -z $APP_ID ]]; then
	echo "Error: Provide app_id parameter"
	exit 1
fi

FOOT_OPTS=(--app-id="$APP_ID")
if [[ -n $TERM ]]; then
	FOOT_OPTS+=(--term="$TERM")
fi
if [[ -n $TITLE ]]; then
	FOOT_OPTS+=(--title="$TITLE")
fi

if [[ ${#COMMAND[@]} -gt 0 ]]; then
	WINDOW_ID=$(niri msg -j windows | jq -r ".[] | select(.app_id==\"$APP_ID\") | .id")
	if [ -n "$WINDOW_ID" ]; then
		niri msg action focus-window --id "$WINDOW_ID"
		niri msg action close-window
	else
		exec footclient "${FOOT_OPTS[@]}" -- "${COMMAND[@]}"
	fi
else
	echo "No command provided after '--'."
fi
