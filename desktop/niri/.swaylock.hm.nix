{
  config,
  ...
}:
let
  c = config.modules.themes.colors;
  a = config.modules.themes.assets;
  f = config.modules.fonts.interface;
in
{
  programs.swaylock = {
    enable = true;
    settings = {
      show-failed-attempts = true;
      font = f.name;
      image = "${a.wallpaper}";
      clock = true;
      indicator-radius = 250;
      indicator-thickness = 30;
      scaling = "fill";
      grace = 2;
      ring-color = c.base17;
      key-hl-color = c.base12;
      line-color = "00000000";
      inside-color = "00000088";
      separator-color = "00000000";
    };
  };

}
