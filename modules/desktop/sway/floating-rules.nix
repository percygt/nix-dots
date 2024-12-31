{
  desktop,
  lib,
  config,
  ...
}:
let
  mapApps =
    {
      command,
      criterias,
      ...
    }:
    map (criteria: {
      command = lib.concatStrings [
        "floating enable, "
        command
      ];
      inherit criteria;
    }) criterias;
in
{
  config = lib.mkIf (desktop == "sway") {
    wayland.windowManager.sway.config.window.commands = [
      {
        command = ''inhibit_idle fullscreen, border pixel'';
        criteria.app_id = ".*";
      }
    ] ++ lib.flatten (map mapApps config.modules.desktop.sway.floatingRules);
  };
}
