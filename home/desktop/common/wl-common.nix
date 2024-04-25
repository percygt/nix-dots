{pkgs, ...}: {
  services = {
    avizo = {
      enable = true;
      settings = {
        default = {
          time = 1.0;
          y-offset = 0.5;
          fade-in = 0.1;
          fade-out = 0.2;
          padding = 10;
        };
      };
    };
    clipman.enable = true;

    wlsunset = {
      enable = true;
      latitude = "51.51";
      longitude = "-2.53";
    };
  };

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    Unit.Description = "polkit-gnome-authentication-agent-1";
    Install.WantedBy = ["graphical-session.target"];
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
