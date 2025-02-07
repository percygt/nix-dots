{
  lib,
  config,
  pkgs,
  ...
}:
let
  swayCfg = config.wayland.windowManager.sway;
  mod = swayCfg.config.modifier;
in
{
  wayland.windowManager.sway.config.keybindings = lib.mkOptionDefault {
    "${mod}+m" =
      "exec ddapp -t 'btop' -m false -h 90 -w 90 -- 'footclient --title=SystemMonitor --app-id=btop -- btop'";
    "${mod}+b" =
      "exec ddapp -t 'bluetooth' -m false -h 50 -w 50 -- 'footclient --title=BluetoothMonitor --app-id=bluetooth -- bluetui'";
    "${mod}+v" =
      "exec ddapp -t 'volume' -m false -h 50 -w 50 -- 'footclient --title=VolumeControl --app-id=volume -- ncpamixer'";
  };
  programs = {
    btop = {
      enable = true;
      settings = {
        color_theme = "tokyo-night";
        theme_background = false;
        vim_keys = true;
      };
    };
  };
  home.packages = with pkgs; [
    # tui
    # tui-network
    impala
    ncpamixer # Terminal mixer for PulseAudio inspired by pavucontrol
    bluetui # UI for managing bluetooth on Linux
    lazyjournal # TUI for journalctl, file system logs, as well as Docker and Podman containers
  ];
}
