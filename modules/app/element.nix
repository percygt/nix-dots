{ lib, config, ... }:
{
  config = lib.mkIf config.modules.app.chromium-webapps.element.enable {
    modules.desktop.sway.floatingRules = [
      {
        command = ''resize set width 80ppt height 80ppt, move position center'';
        criterias = [ { app_id = "chrome-app.element.io__-WebApp-element"; } ];
      }
    ];

    programs.chromium.webapps.element = {
      enable = true;
      url = "https://app.element.io";
      mimeType = [ "x-scheme-handler/element" ];
      categories = [
        "Network"
        "InstantMessaging"
        "Chat"
        "VideoConference"
      ];
    };
  };
}
