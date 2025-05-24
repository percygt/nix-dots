{ lib, config, ... }:
{
  config = lib.mkIf config.modules.app.chromium.webapps.zoom.enable {
    modules.desktop.sway.floatingRules = [
      {
        command = ''resize set width 80ppt height 80ppt, move position center'';
        criterias = [ { app_id = "chrome-discord.com__channels_@me-WebApp-discord"; } ];
      }
    ];
    programs.chromium.webapps.discord = {
      enable = true;
      url = "https://discord.com/channels/@me";
      comment = "All-in-one voice and text chat for gamers that's free, secure, and works on both your desktop and phone.";
      genericName = "Internet Messenger";
      categories = [
        "Network"
        "InstantMessaging"
      ];
    };
  };
}
