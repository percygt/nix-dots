{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writers.writeBashBin "ddapp" { }
      #  dropdown/scratchpad app
      # bash
      ''
        # defaults
        height=100ppt
        width=100ppt
        minimize_auto=true

        while getopts h:w:t:n:m:c: flag
        do
          case "''${flag}" in
            h) height=''${OPTARG};;
            w) width=''${OPTARG};;
            t) target=''${OPTARG} ;;
            n) name=''${OPTARG} ;;
            m) minimize_auto=''${OPTARG} ;;
            c) command=''${OPTARG};;
            *) notify-send "You f*ck up" "''${OPTARG}" ;;
          esac
        done
        nodes=$(swaymsg -t get_tree | jq -r 'recurse(.nodes[]?).floating_nodes[]')
        if [ -n "$name" ]; then
          program_data=$( echo $nodes |
            jq "select((.app_id==\"$target\" or .window_properties.class==\"$target\") and (.name|test(\"$name\")))" )
        else
          program_data=$( echo $nodes |
            jq "select(.app_id==\"$target\" or .window_properties.class==\"$target\")" )
        fi
        AUTO_MINIMIZE="/tmp/ddapp_auto_minimize"
        if [[ "$program_data" ]]; then
          id=$( echo "$program_data" | jq ".id" | head -n 1)
          focused=$( echo "$program_data" | jq ".focused" | head -n 1)
          params="[con_id=$id]"
          auto_minimize_win=$(echo $nodes |
            jq -r "select(((.id == \"$id\")|not) and .visible and (.sticky|not)) |
              (if .app_id then (\"[app_id=\" + .app_id + \"]\") else (\"[class=\" + .window_properties.class + \"]\") end)" |
                while read app; do
                  if grep -Fxq "$app" "$AUTO_MINIMIZE"; then
                    echo "$app"
                  fi
                done
            )
          if [[ "$focused" == "true" ]]; then
            swaymsg "$params move window to scratchpad"
          else
            if [ -n "$auto_minimize_win" ]; then
              for id in $auto_minimize_win; do
                swaymsg "$param move window to scratchpad"
              done
            fi
            swaymsg "$params move window to workspace current"
            swaymsg "$params focus"
            swaymsg "$params resize set $height $width , move position center"
          fi
        else
          if [ -n "$name" ]; then
            swaymsg "for_window [app_id=$target title=$name] 'move to scratchpad ; scratchpad show ; floating enable ; resize set $height $width ; move position center'"
            swaymsg "for_window [class=$target title=$name] 'move to scratchpad ; scratchpad show ; floating enable ; resize set $height $width ; move position center'"
          else
            swaymsg "for_window [app_id=$target] 'move to scratchpad ; scratchpad show ; floating enable ; resize set $height $width ; move position center'"
            swaymsg "for_window [class=$target] 'move to scratchpad ; scratchpad show ; floating enable ; resize set $height $width ; move position center'"
          fi

          if [ "$minimize_auto" = true ] ; then
            if ! grep -Fxq "[app_id=$target]" "$AUTO_MINIMIZE"; then
              echo "[app_id=$target]" >> "$AUTO_MINIMIZE"
            fi
            if ! grep -Fxq "[class=$target]" "$AUTO_MINIMIZE"; then
              echo "[class=$target]" >> "$AUTO_MINIMIZE"
            fi
          fi

          swaymsg exec $command
          auto_minimize_win=$(echo $nodes |
            jq -r "select(.visible and (.sticky|not)) |
              (if .app_id then (\"[app_id=\" + .app_id + \"]\") else (\"[class=\" + .window_properties.class + \"]\") end)" |
              while read app; do
                if grep -Fxq "$app" "$AUTO_MINIMIZE"; then
                  echo "$app"
                fi
              done
            )
          if [ -n "$auto_minimize_win" ]; then
            for param in $auto_minimize_win; do
              swaymsg "$param move window to scratchpad"
            done
          fi
        fi
      ''
    )
  ];
}
