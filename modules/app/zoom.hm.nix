{
  lib,
  config,
  ...
}:
let
  swayCfg = config.wayland.windowManager.sway;
  mod = swayCfg.config.modifier;
in
{

  config = lib.mkIf config.modules.app.chromium-webapps.zoom.enable {
    wayland.windowManager.sway = {
      config.keybindings = lib.mkOptionDefault {
        "${mod}+z" =
          "exec ddapp -t \"chrome-app.zoom.us__wc-WebApp-zoom\" -h 90 -w 90 -- ${config.xdg.desktopEntries.zoom.exec}";
      };
    };

    programs.chromium.webapps.zoom = {
      enable = true;
      url = "https://app.zoom.us/wc";
      comment = "Zoom Video Conference";
      genericName = "Zoom Client";
      categories = [
        "Network"
        "InstantMessaging"
        "VideoConference"
        "Telephony"
      ];
    };
  };
}
