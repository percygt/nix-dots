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
        while getopts h:w:a:l:t:c: flag
        do
            case "''${flag}" in
                h) height=''${OPTARG};;
                w) width=''${OPTARG};;
                a) win_app_id=''${OPTARG} ;;
                l) win_class=''${OPTARG} ;;
                t) win_title=''${OPTARG} ;;
                c) command=''${OPTARG};;
                *) notify-send "You f*ck up" "''${OPTARG}" ;;
            esac
        done
        if [ -n "$win_app_id" ]; then
          if [ -n "$win_title" ]; then
            title=" title=$win_title"
            visible_floating_win=$(swaymsg -t get_tree |
              jq -r "recurse(.nodes[]?).floating_nodes[] | \
                select(.app_id != \"$win_app_id\" and (.name|test(\"$win_title\")|not) and .visible) | \
                .app_id + \",\" + .name")
          else
            visible_floating_win=$(swaymsg -t get_tree |
              jq -r "recurse(.nodes[]?).floating_nodes[] | \
                select(.app_id != \"$win_app_id\" and .visible) | \
                .app_id + \",\" + .name")
          fi
          if [ -n "$visible_floating_win" ]; then
            for win in $visible_floating_win; do
              notify-send $win
              a=$(echo "$win" | cut -d',' -f1)
              b=$(echo "$win" | cut -d',' -f2)
              t=$(echo "$b" | awk '{print $1}')
              swaymsg "[app_id=$a title=$t] scratchpad show"
            done
          fi
          params="[app_id=$win_app_id$title]"
        elif [ -n "$win_class" ]; then
          if [ -n "$win_title" ]; then
            title=" title=$win_title"
            visible_floating_win=$(swaymsg -t get_tree |
              jq -r "recurse(.nodes[]?).floating_nodes[] | select(.class != \"$win_class\" and (.name|test(\"$win_title\")|not) and .visible) | .class + \",\" + .name")
          else
            visible_floating_win=$(swaymsg -t get_tree |
              jq -r "recurse(.nodes[]?).floating_nodes[] | select(.app_id != \"$win_class\" and .visible) | .class + \",\" + .name")
          fi
          if [ -n "$visible_floating_win" ]; then
            for win in $visible_floating_win; do
              c=$(echo "$win" | cut -d',' -f1)
              b=$(echo "$win" | cut -d',' -f2)
              t=$(echo "$b" | awk '{print $1}')
              swaymsg "[class=$c title=$t] scratchpad show"
            done
          fi
          params="[class=$win_class$title]"
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
