{
  pkgs,
  config,
  ...
}: {
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      screenshots = true;
      clock = true;
      indicator = true;
      indicator-radius = 200;
      indicator-thickness = 7;
      effect-blur = "7x5";
      grace = 2;
    };
  };

  systemd.user.services.swaylock = {
    Unit.Description = "Lock screen";
    Service.ExecStart = "${config.programs.swaylock.package}/bin/swaylock";
  };
}
