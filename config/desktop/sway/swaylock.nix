{ pkgs, config, ... }:
let
  c = config.modules.theme.colors;
  a = config.modules.theme.assets;
  f = config.modules.fonts.interface;
in
{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      font = f.name;
      image = "${a.wallpaper}";
      indicator-idle-visible = false;
      font-size = 24;
      screenshots = true;
      clock = true;
      effect-vignette = "0.5:0.5";
      timestr = "󰥔 %Hh %Mm %Ss";
      datestr = "󰃭 %b-%d-%Y";
      indicator = true;
      indicator-radius = 200;
      indicator-thickness = 30;
      indicator-x-position = 965;
      indicator-y-position = 540;
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

  systemd.user.services.swaylock = {
    Unit.Description = "Lock screen";
    Service.ExecStart = "${config.programs.swaylock.package}/bin/swaylock";
  };
}
