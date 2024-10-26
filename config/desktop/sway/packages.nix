{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (pkgs.writers.writeBashBin "ddapp" { }
      #bash
      ''
        while getopts p:c: flag
        do
            case "''${flag}" in
                p) params=''${OPTARG};;
                c) command=''${OPTARG};;
            esac
        done
        if swaymsg "$params scratchpad show"
        then
            swaymsg "$params resize set 100ppt 100ppt , move position center"
        else
            swaymsg "for_window $params 'floating enable ; resize set 100ppt 100ppt ; move position center ; move to scratchpad ; scratchpad show'"
            exec $command
        fi
      ''
    )
    swayidle
    brightnessctl
    autotiling
    wlsunset
    grim
    kanshi
    libnotify
    pamixer
    wev
    slurp
    wdisplays
    wl-clipboard
    ydotool
    xdg-utils
    xwayland
    wl-screenrec
    libnotify
  ];
}
