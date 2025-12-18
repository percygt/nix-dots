#!/usr/bin/env bash

while getopts h:w:t:n:m:k:c: flag; do
  case "${flag}" in
  t) TARGET=${OPTARG} ;;
  *) notify-send "You f*cked up" "${OPTARG}" ;;
  esac
done
WORKSPACES=$(niri msg --json workspaces)
ACTIVE_WORKSPACE=$(echo "$WORKSPACES" | jq -r ".[] | select(.is_focused==true) | .id")

WINDOWS=$(niri msg --json windows)
APP_DATA=$(echo "$WINDOWS" | jq -r "first(.[] | select(.app_id == \"$TARGET\"))")

WINDOW_ID=$(echo "$APP_DATA" | jq -r ".id" | head -n 1)
FOCUSED=$(echo "$APP_DATA" | jq -r ".focused" | head -n 1)

if [[ "$APP_DATA" ]]; then
  if [[ $(echo "$APP_DATA" | jq -r "select(.workspace_id!=$ACTIVE_WORKSPACE)") ]]; then
    echo hey
  fi
fi
# if [[ "$program_data" ]]; then
#   nirius scratchpad-show "$param"
# else
#   after_double_dash=false
#   args_after_dash=()
#
#   for arg in "$@"; do
#     if [ "$after_double_dash" = true ]; then
#       args_after_dash+=("$arg")
#     fi
#
#     # Set the flag to true after '--'
#     if [ "$arg" == "--" ]; then
#       after_double_dash=true
#     fi
#   done
#   id=$(echo "$program_data" | jq -r ".id" | head -n 1)
#   id_param="--id=$id"
#   nirius focus-or-spawn "$param" "${args_after_dash[@]}" && nirius scratchpad-toggle "$param" --no-move && niri msg action toggle-window-floating "$id_param"
# fi
