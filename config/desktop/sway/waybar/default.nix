{
  pkgs,
  lib,
  libx,
  config,
  ...
}:
let
  inherit (libx) toRasi mkLiteral sway;
  inherit (sway) viewRebuildLogCmd;
  daylight = pkgs.writeBabashkaScript {
    name = "daylight";
    text = libx.clj.daylight;
  };
  waybarRebuild = pkgs.writeShellApplication {
    name = "waybar-rebuild-exec";
    runtimeInputs = [
      pkgs.coreutils-full
      pkgs.systemd
      pkgs.gnugrep
    ];
    text = ''
      status="$(systemctl is-active nixos-rebuild.service || true)"
      if grep -q "inactive" <<< "$status"; then
        printf "rebuild: "
      elif grep -q "active" <<< "$status"; then
        printf "rebuild: "
      elif grep -q "failed" <<< "$status"; then
        printf "rebuild: "
      fi
    '';
  };
  waybar_config = import ./config.nix {
    inherit
      lib
      config
      daylight
      waybarRebuild
      viewRebuildLogCmd
      ;
  };
in
{
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
    style = toRasi (import ./theme.nix { inherit mkLiteral config; }).theme;
    settings = [
      (waybar_config // { output = "HDMI-A-1"; })
      (
        waybar_config
        // {
          ipc = true;
          id = "bar-1";
          output = "eDP-1";
        }
      )
    ];
  };
}
