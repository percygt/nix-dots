{
  pkgs,
  lib,
  libx,
  ...
}: let
  inherit (libx) toRasi mkLiteral fonts colors;
  daylight = pkgs.writeBabashkaScript {
    name = "daylight";
    text = libx.clj.daylight;
  };
  waybar_config = import ./config.nix {inherit lib daylight colors;};
in {
  # needed for mpris
  services.playerctld.enable = true;
  # add binary path to waybar systemd environment
  home.packages = with pkgs; [
    toggle-service
    toggle-sway-window
  ];

  programs.waybar = {
    enable = true;
    package = pkgs.stash.waybar;
    style = toRasi (import ./theme.nix {inherit mkLiteral fonts colors;}).theme;
    settings = [
      (waybar_config
        // {
          output = "HDMI-A-1";
        })
      (waybar_config
        // {
          ipc = true;
          id = "bar-1";
          output = "eDP-1";
        })
    ];
  };
}
