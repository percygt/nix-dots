{ pkgs, config, ... }:
let
  c = config.modules.theme.colors;
  a = config.modules.theme.assets;
  f = config.modules.fonts.interface;
in
{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects.overrideAttrs (oldAttrs: {
      depsBuildBuild = [ pkgs.pkg-config ];
    });
    settings = {
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
}
