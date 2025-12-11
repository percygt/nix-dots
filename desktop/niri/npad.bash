#!/usr/bin/env bash
# defaults
height=100
width=100
minimize_auto=true
kill=false

while getopts h:w:t:n:m:k:c: flag; do
  case "${flag}" in
  h) height=${OPTARG} ;;
  w) width=${OPTARG} ;;
  t) target=${OPTARG} ;;
  n) name=${OPTARG} ;;
  m) minimize_auto=${OPTARG} ;;
  k) kill=${OPTARG} ;;
  # c) command=${OPTARG};;
  *) notify-send "You f*cked up" "${OPTARG}" ;;
  esac
done
windows=$(niri msg --json windows | jq '.[] | select(.is_floating==true)')

if [ -n "$name" ]; then
  program_data=$(echo "$windows" |
    jq -r "select((.app_id==\"$target\" and (.name|test(\"$name\")))")
else
  program_data=$(echo "$windows" |
    jq -r "select(.app_id==\"$target\")")
fi

# AUTO_MINIMIZE="/tmp/npad_auto_minimize"
if [[ "$program_data" ]]; then
  id=$(echo "$program_data" | jq -r ".id" | head -n 1)
  focused=$(echo "$program_data" | jq -r ".is_focused" | head -n 1)
  params="--id=$id"

  # auto_minimize_win=$(
  #   echo "$windows" |
  #     jq -r "select(((.id == \"$id\")|not)) | (\"[app_id=\" + .app_id + \"]\")" |
  #     while read -r app; do
  #       if grep -Fxq "$app" "$AUTO_MINIMIZE"; then
  #         echo "$app"
  #       fi
  #     done
  # )

  if [[ "$focused" == "true" ]]; then
    if [[ "$kill" == true ]]; then
      niri msg action close-window "$params"
    else
      swaymsg "$params move window to scratchpad"
    fi
  else
    if [ "$minimize_auto" = true ]; then
      if [ -n "$auto_minimize_win" ]; then
        for param in $auto_minimize_win; do
          swaymsg "$param move window to scratchpad"
        done
      fi
    fi
    swaymsg "$params move window to workspace current"
    swaymsg "$params focus"
    if [[ "$height" == 100 ]]; then
      swaymsg "$params resize set $height ppt $width ppt, move position center"
    fi
  fi
# else
#   if [ -n "$name" ]; then
#     swaymsg "for_window [app_id=$target title=$name] 'floating enable ; move to scratchpad ; scratchpad show ; resize set $height ppt $width ppt ; move position center'"
#     swaymsg "for_window [class=$target title=$name] 'floating enable ; move to scratchpad ; scratchpad show ; resize set $height ppt $width ppt ; move position center'"
#   else
#     swaymsg "for_window [app_id=$target] 'floating enable ; move to scratchpad ; scratchpad show ; resize set $height ppt $width ppt ; move position center'"
#     swaymsg "for_window [class=$target] 'floating enable ; move to scratchpad ; scratchpad show ; resize set $height ppt $width ppt ; move position center'"
#   fi
#
#   if [ "$minimize_auto" = true ]; then
#     if ! grep -Fxq "[app_id=$target]" "$AUTO_MINIMIZE"; then
#       echo "[app_id=$target]" >>"$AUTO_MINIMIZE"
#     fi
#     if ! grep -Fxq "[class=$target]" "$AUTO_MINIMIZE"; then
#       echo "[class=$target]" >>"$AUTO_MINIMIZE"
#     fi
#     auto_minimize_win=$(
#       echo "$windows" |
#         jq -r "select(.visible and (.sticky|not)) |
#                 (if .app_id then (\"[app_id=\" + .app_id + \"]\") else (\"[class=\" + .window_properties.class + \"]\") end)" |
#         while read -r app; do
#           if grep -Fxq "$app" "$AUTO_MINIMIZE"; then
#             echo "$app"
#           fi
#         done
#     )
#     if [ -n "$auto_minimize_win" ]; then
#       for param in $auto_minimize_win; do
#         swaymsg "$param move window to scratchpad"
#       done
#     fi
#   fi
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
#
#   swaymsg exec "${args_after_dash[@]}"
fi
