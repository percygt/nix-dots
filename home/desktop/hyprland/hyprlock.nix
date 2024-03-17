{
  self,
  lib,
  pkgs,
  colors,
  ...
}: let
  inherit (import "${self}/lib/mkUI.nix" {inherit pkgs;}) cc fonts themes;
  inherit (cc) hexToRgb;
in {
  programs.hyprlock = {
    enable = true;

    general = {
      grace = 5;
      hide_cursor = true;
    };

    backgrounds = [
      {
        path = "${themes.wallpaper}";
        blur_passes = 2;
        blur_size = 6;
      }
    ];

    input-fields = [
      {
        size.width = 250;
        outer_color = "rgb(${hexToRgb "#${colors.normal.black}"})";
        inner_color = "rgb(${hexToRgb "#${colors.default.background}"})";
        font_color = "rgb(${hexToRgb "#${colors.default.foreground}"})";
        placeholder_text = "";
      }
    ];

    labels = [
      {
        text = "Hello";
        color = "rgba(${hexToRgb "#${colors.bold}"}, 1.0)";
        font_family = fonts.ui.name;
        font_size = 64;
      }
      {
        text = "$TIME";
        color = "rgba(${hexToRgb "#${colors.normal.magenta}"}, 1.0)";
        font_family = fonts.ui.name;
        font_size = 32;
        position.y = 160;
      }
    ];
  };

  services.hypridle = {
    enable = true;
    lockCmd = "${lib.getExe pkgs.hyprlock}";
    beforeSleepCmd = "${lib.getExe pkgs.hyprlock}";
    listeners = [
      {
        timeout = 300;
        onTimeout = "${lib.getExe pkgs.hyprlock}";
      }
      {
        timeout = 305;
        onTimeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
        onResume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
    ];
  };
}
