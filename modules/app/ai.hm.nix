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
  config = lib.mkIf config.modules.app.chromium-webapps.ai.enable {
    wayland.windowManager.sway = {
      config.keybindings = lib.mkOptionDefault {
        "${mod}+Shift+i" =
          "exec ddapp -t 'chrome-chatgpt.com__-WebApp-ai' -h 90 -w 90 -- '${g.xdg.desktopEntries.ai.exec}'";
      };
    };

    programs.chromium.webapps.ai = {
      enable = true;
      url = "https://chatgpt.com";
      comment = "ChatGPT: Get instant answers, find inspiration, learn something new";
      genericName = "ChatGPT";
      categories = [ "Network" ];
    };
  };
}
