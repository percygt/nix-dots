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
  wayland.windowManager.sway = {
    config.keybindings = lib.mkOptionDefault {
      "${mod}+Shift+i" = "exec ddapp -t 'chrome-chatgpt.com__-WebApp-ai' -m false -h 90 -w 90 -- '${config.xdg.desktopEntries.ai.exec}'";
    };
  };

  programs.chromium.webapps.ai = {
    enable = true;
    url = "https://chatgpt.com";
    comment = "ChatGPT: Get instant answers, find inspiration, learn something new";
    genericName = "ChatGPT";
    categories = [ "Network" ];
  };
}
