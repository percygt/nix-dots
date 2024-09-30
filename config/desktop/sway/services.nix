{ pkgs, inputs, ... }:
{
  imports = [ inputs.wayland-pipewire-idle-inhibit.homeModules.default ];
  services = {
    clipman.enable = true;

    wlsunset = {
      enable = true;
      systemdTarget = "null.target";
      latitude = "14.5";
      longitude = "120.9";
      temperature = {
        day = 7000;
        night = 3000;
      };
    };

    wayland-pipewire-idle-inhibit = {
      enable = true;
      package = pkgs.wayland-pipewire-idle-inhibit;
      systemdTarget = "sway-session.target";
      settings = {
        verbosity = "INFO";
        idle_inhibitor = "wayland";
        media_minimum_duration = 30;
        sink_whitelist = [ ];
        node_blacklist = [ ];
      };
    };
  };

  systemd.user.services = {
    polkit-gnome-authentication-agent-1 = {
      Unit.Description = "polkit-gnome-authentication-agent-1";
      Install.WantedBy = [ "sway-session.target" ];
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "always";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
