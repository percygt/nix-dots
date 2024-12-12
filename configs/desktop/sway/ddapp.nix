{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writers.writeBashBin "ddapp" { }
      #  dropdown/scratchpad app
      # bash
      ''
        height=100ppt
        width=100ppt
        while getopts h:w:t:n:c: flag
        do
            case "''${flag}" in
                h) height=''${OPTARG};;
                w) width=''${OPTARG};;
                t) target=''${OPTARG} ;;
                n) name=''${OPTARG} ;;
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
        if [[ "$program_data" ]]; then
            id=$( echo "$program_data" | jq ".id" | head -n 1)
            focused=$( echo "$program_data" | jq ".focused" | head -n 1)
            params="[con_id=$id]"
            visible_floating_win=$(echo $nodes |
              jq -r "select(((.id == \"$id\")|not) and .visible and (.sticky|not)) | .id")
            if [[ "$focused" == "true" ]]; then
              swaymsg "$params move window to scratchpad"
            else
              if [ -n "$visible_floating_win" ]; then
                for id in $visible_floating_win; do
                  swaymsg "[con_id=$id] move window to scratchpad"
                done
              fi
              swaymsg "$params move window to workspace current"
              swaymsg "$params focus"
              swaymsg "$params resize set $height $width , move position center"
            fi
        else
            if [ -n "$name" ]; then
              swaymsg "for_window [app_id=$target title=$name] 'floating enable ; resize set $height $width ; move position center ; move to scratchpad ; scratchpad show'"
              swaymsg "for_window [class=$target title=$name] 'floating enable ; resize set $height $width ; move position center ; move to scratchpad ; scratchpad show'"
            else
              swaymsg "for_window [app_id=$target] 'floating enable ; resize set $height $width ; move position center ; move to scratchpad ; scratchpad show'"
              swaymsg "for_window [class=$target] 'floating enable ; resize set $height $width ; move position center ; move to scratchpad ; scratchpad show'"
            fi
            swaymsg exec $command
            visible_floating_win=$(echo $nodes |
              jq -r "select(.visible) | .id")
            if [ -n "$visible_floating_win" ]; then
              for id in $visible_floating_win; do
                swaymsg "[con_id=$id] move window to scratchpad"
              done
            fi
        fi
      ''
    )
  ];
}
