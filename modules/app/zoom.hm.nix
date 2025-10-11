{
  lib,
  config,
  ...
}:
let
  g = config._global;
  swayCfg = config.wayland.windowManager.sway;
  mod = swayCfg.config.modifier;
in
{

  config = lib.mkIf config.modules.app.chromium-webapps.zoom.enable {
    wayland.windowManager.sway = {
      config.keybindings = lib.mkOptionDefault {
        "${mod}+z" =
          "exec ddapp -t \"chrome-app.zoom.us__wc-WebApp-zoom\" -h 90 -w 90 -- ${g.xdg.desktopEntries.zoom.exec}";
      };
    };

    programs.chromium.webapps.zoom = {
      enable = true;
      url = "https://app.zoom.us/wc";
      icon = "zoom-desktop";
      comment = "Zoom Video Conference";
      name = "Zoom Client";
      categories = [
        "Network"
        "InstantMessaging"
        "VideoConference"
        "Telephony"
      ];
    };
  };
}
