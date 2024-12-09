{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writers.writeBashBin "ddapp" { }
      #  dropdown/scratchpad app
      #bash
      ''
        height=100ppt
        width=100ppt
        params="[]"
        visible_floating_win=""
        while getopts h:w:a:l:t:c: flag
        do
            case "''${flag}" in
                h) height=''${OPTARG};;
                w) width=''${OPTARG};;
                a) WIN_APP_ID=''${OPTARG} ;;
                l) WIN_CLASS=''${OPTARG} ;;
                t) WIN_TITLE=''${OPTARG} ;;
                c) command=''${OPTARG};;
                *) notify-send "You f*ck up" "''${OPTARG}" ;;
            esac
        done
        if [ -n "$WIN_APP_ID" ]; then
          if [ -n "$WIN_TITLE" ]; then
            title=" title=$WIN_TITLE"
            visible_floating_win=$(swaymsg -t get_tree |
              jq -r 'recurse(.nodes[]?).floating_nodes[] |
                select((((.app_id=="$WIN_APP_ID") and (.name|startswith("$WIN_TITLE")))|not) and .visible) |
                .app_id + "," + (.name|sub(" .*$"; ""))')
          else
            visible_floating_win=$(swaymsg -t get_tree |
              jq -r 'recurse(.nodes[]?).floating_nodes[] |
                select((.app_id!="$WIN_APP_ID") and .visible) |
                .app_id + "," + (.name|sub(" .*$"; ""))')
          fi
          if [ -n "$visible_floating_win" ]; then
            for win in $visible_floating_win; do
              a=$(echo "$win" | cut -d',' -f1)
              b=$(echo "$win" | cut -d',' -f2 | awk '{print $1}')
              swaymsg "[app_id=$a title=$b] scratchpad show"
            done
          fi
          params="[app_id=$WIN_APP_ID$title]"
        elif [ -n "$WIN_CLASS" ]; then
          if [ -n "$WIN_TITLE" ]; then
            title=" title=$WIN_TITLE"
            visible_floating_win=$(swaymsg -t get_tree |
              jq -r 'recurse(.nodes[]?).floating_nodes[] | select(.app_id != "$WIN_CLASS" and (.name|startswith("$WIN_TITLE")|not) and .visible) | .class + "," + (.name|sub(" .*$"; ""))')
          else
            visible_floating_win=$(swaymsg -t get_tree |
              jq -r 'recurse(.nodes[]?).floating_nodes[] | select(.app_id != "$WIN_CLASS" and .visible) | .class + "," + (.name|sub(" .*$"; ""))')
          fi
          if [ -n "$visible_floating_win" ]; then
            for win in $visible_floating_win; do
              c=$(echo "$win" | cut -d',' -f1)
              b=$(echo "$win" | cut -d',' -f2 | awk '{print $1}')
              swaymsg "[class=$c title=$b] scratchpad show"
            done
          fi
          params="[class=$WIN_CLASS$title]"
        fi

        if swaymsg "$params scratchpad show"
        then
            swaymsg "$params resize set $height $width , move position center"
        else
            swaymsg "for_window $params 'floating enable ; resize set $height $width ; move position center ; move to scratchpad ; scratchpad show'"
            exec $command
        fi
      ''
    )
  ];
}
