{
  pkgs,
  lib,
  libx,
  desktop,
  config,
  ...
}: let
  inherit (libx) toRasi mkLiteral fonts colors mkWaybarFont;
  swaypkg = config.wayland.windowManager.${desktop}.package;
  daylight = pkgs.writeBabashkaScript {
    name = "daylight";
    text = libx.clj.daylight;
  };
  waybar_config = import ./config.nix {inherit lib daylight mkWaybarFont colors;};
in {
  # needed for mpris
  services.playerctld.enable = true;
  services.network-manager-applet.enable = true;
  # add binary path to waybar systemd environment
  home.packages = with pkgs; [
    toggle-service
    toggle-sway-window
  ];
  systemd.user.services.waybar.Service.Environment = lib.mkForce "PATH=${lib.makeBinPath (with pkgs; [
    swaypkg
    wpa_supplicant_gui
    pulseaudio
    toggle-service
    toggle-sway-window
    foot
    brightnessctl
    pamixer
    systemd
    config.programs.btop.package
  ])}";

  programs.waybar = {
    enable = true;
    style = toRasi (import ./theme.nix {inherit mkLiteral fonts colors;}).theme;
    systemd.enable = true;
    systemd.target = "sway-session.target";
    settings = [
      (waybar_config
        // {
          position = "top";
          output = "HDMI-A-1";
        })
      (waybar_config
        // {
          position = "bottom";
          output = "eDP-1";
        })
    ];
  };
}
