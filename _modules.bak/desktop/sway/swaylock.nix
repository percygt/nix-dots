{
  pkgs,
  lib,
  config,
  ...
}:
let
  c = config.modules.themes.colors;
  a = config.modules.themes.assets;
  f = config.modules.fonts.interface;
  cfg = config.wayland.windowManager.sway.config;
  mod = cfg.modifier;
in
{
  config = lib.mkIf config.modules.desktop.sway.swaylock.enable {
    wayland.windowManager.sway = {
      config.keybindings = lib.mkOptionDefault {
        "${mod}+l" = "exec swaylock";
      };
    };
    services.swayidle.events = [
      {
        event = "lock";
        command = "swaylock --grace 0";
      }
      {
        event = "unlock";
        command = "pkill -SIGUSR1 swaylock";
      }
      {
        event = "before-sleep";
        command = "swaylock --grace 0";
      }
    ];
    services.swayidle.timeouts = [
      {
        timeout = 15 * 60;
        command = "swaylock --grace 0";
      }
    ];
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        daemonize = true;
        show-failed-attempts = true;
        font = f.name;
        image = "${a.wallpaper}";
        indicator-idle-visible = false;
        screenshots = true;
        clock = true;
        effect-vignette = "0.5:0.25 ";
        timestr = "%I:%M";
        datestr = "%a, %b%d";
        indicator = true;
        indicator-radius = 250;
        indicator-thickness = 30;
        effect-blur = "3x5";
        scaling = "fill";
        grace = 2;
        ring-color = c.base17;
        key-hl-color = c.base12;
        line-color = "00000000";
        inside-color = "00000088";
        separator-color = "00000000";
        fade-in = 0.2;
      };
    };
  };
}
