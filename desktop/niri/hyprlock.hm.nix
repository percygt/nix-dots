{
  config,
  lib,
  pkgs,
  ...
}:
let
  a = config.modules.themes.assets;
  f = config.modules.fonts.interface;
  date = lib.getExe' pkgs.coreutils "date";
in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = false;
        ignore_empty_input = true;
      };

      background = [
        {
          monitor = "eDP-1";
          path = "${a.wallpaper}";
          blur_passes = 3;
          blur_size = 12;
          noise = "0.1";
          contrast = "1.3";
          brightness = "0.2";
          vibrancy = "0.5";
          vibrancy_darkness = "0.3";
        }
        {
          monitor = "HDMI-A-1";
          path = "${a.wallpaper}";
          blur_passes = 3;
          blur_size = 12;
          noise = "0.1";
          contrast = "0.8";
          brightness = "0.1";
          vibrancy = "0.2";
          vibrancy_darkness = "0.3";
        }
      ];

      input-field = [
        {
          monitor = "";

          size = "300, 50";
          valign = "bottom";
          position = "0%, 10%";

          outline_thickness = 1;

          font_color = "rgb(211, 213, 202)";
          outer_color = "rgba(29, 38, 33, 0.6)";
          inner_color = "rgba(15, 18, 15, 0.1)";
          check_color = "rgba(141, 186, 100, 0.5)";
          fail_color = "rgba(229, 90, 79, 0.5)";

          placeholder_text = "Enter Password";

          dots_spacing = 0.2;
          dots_center = true;

          shadow_color = "rgba(5, 7, 5, 0.1)";
          shadow_size = 7;
          shadow_passes = 2;
        }
      ];

      label = [
        {
          monitor = "";
          text = ''
            cmd[update:1000] echo "<span font-weight='light' >$(${date} +'%I %M %S')</span>"
          '';
          font_size = 200;
          font_family = f.name;

          color = "rgb(8a9e6b)";

          position = "0%, 2%";

          valign = "center";
          halign = "center";

          shadow_color = "rgba(5, 7, 5, 0.1)";
          shadow_size = 20;
          shadow_passes = 2;
          shadow_boost = 0.3;
        }
      ];
    };
  };
}
