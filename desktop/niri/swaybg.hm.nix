{
  config,
  pkgs,
  lib,
  ...
}:
let
  a = config.modules.themes.assets;
in
{
  systemd.user.services.swaybg = {
    Unit = {
      Description = "Wayland wallpaper daemon";
      ConditionEnvironment = "WAYLAND_DISPLAY";
      After = [ "niri.service" ];
      Requires = [ "niri.service" ];
      PartOf = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.swaybg} -i ${a.wallpaper}";
      Restart = "on-failure";
    };
  };
}
