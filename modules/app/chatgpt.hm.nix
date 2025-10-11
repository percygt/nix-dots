{
  lib,
  config,
  pkgs,
  ...
}:
let
  g = config._global;
  swayCfg = config.wayland.windowManager.sway;
  mod = swayCfg.config.modifier;
in
{
  config = lib.mkIf config.modules.app.chromium-webapps.chatgpt.enable {
    wayland.windowManager.sway = {
      config.keybindings = lib.mkOptionDefault {
        "${mod}+Shift+i" =
          "exec ddapp -t 'chrome-chatgpt.com__-WebApp-chatgpt' -h 90 -w 90 -- '${g.xdg.desktopEntries.ai.exec}'";
      };
    };

    programs.chromium.webapps.chatgpt = {
      enable = true;
      url = "https://chatgpt.com";
      comment = "ChatGPT: Get instant answers, find inspiration, learn something new";
      icon = pkgs.fetchurl {
        url = "https://pngimg.com/d/chatgpt_PNG1.png";
        sha256 = "1w5zis85rxywlkyalsvcxfmnr0mwl1dsi8lcr7a9wp6f1f4v0sba";
      };
      name = "ChatGPT";
      categories = [ "Network" ];
    };
  };
}
