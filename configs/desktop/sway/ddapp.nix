{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writers.writeBashBin "ddapp" { }
      #bash
      ''
        height=100ppt
        width=100ppt
        while getopts h:w:p:c: flag
        do
            case "''${flag}" in
                h) height=''${OPTARG};;
                w) width=''${OPTARG};;
                p) params=''${OPTARG};;
                c) command=''${OPTARG};;
            esac
        done
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
