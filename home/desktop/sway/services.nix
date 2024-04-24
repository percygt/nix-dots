{
  pkgs,
  lib,
  ...
}: {
  services = {
    clipman.enable = true;

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

    wlsunset = {
      enable = true;
      latitude = "51.51";
      longitude = "-2.53";
    };
  };

  systemd.user.services = {
    blueman-applet = {
      Unit = {
        Description = "Blueman applet";
      };
      Service = {
        ExecStart = "${pkgs.blueman}/bin/blueman-applet";
      };
      Install = {
        WantedBy = ["sway-session.target"];
      };
    };
    nm-applet = {
      Unit = {
        Description = "Network manager applet";
      };
      Service = {
        ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
        Restart = "always";
      };
      Install = {
        WantedBy = ["sway-session.target"];
      };
    };
    polkit-gnome-authentication-agent-1 = {
      Unit.Description = "polkit-gnome-authentication-agent-1";
      Install.WantedBy = ["graphical-session.target"];
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "always";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
    btop = {
      Unit = {
        Description = "Btop system resource dashboard";
      };
      Service = {
        ExecStart = "${lib.getExe pkgs.foot} --app-id=btop ${lib.getExe pkgs.btop}";
        ExecStartPost = "-${pkgs.sway}/bin/swaymsg for_window [app_id=btop] move scratchpad";
        Restart = "always";
      };
      Install = {
        WantedBy = ["sway-session.target"];
      };
    };
  };
}
