{
  config,
  lib,
  pkgs,
  ...
}:
let
  swayCfg = config.wayland.windowManager.sway;
  mod = swayCfg.config.modifier;
in
{
  config = lib.mkIf config.modules.drivers.bluetooth.enable {
    wayland.windowManager.sway.config.keybindings = lib.mkOptionDefault {
      "${mod}+b" =
        "exec ddapp -t 'bluetooth' -h 50 -w 50 -- 'footclient --title=BluetoothMonitor --app-id=bluetooth -- bluetui'";
    };
    home.packages = with pkgs; [ bluetui ];
  };
}
