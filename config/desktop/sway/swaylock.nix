{ pkgs, config, ... }:
let
  c = config.modules.theme.colors;
in
{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      screenshots = true;
      clock = true;
      effect-vignette = "0.5:0.5";
      indicator = true;
      indicator-radius = 200;
      indicator-thickness = 7;
      effect-blur = "7x5";
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
