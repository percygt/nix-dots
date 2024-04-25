{pkgs, ...}: let
  loginctl = "${pkgs.systemd}/bin/loginctl";
  swaymsg = "${pkgs.sway}/bin/swaymsg";
  systemctl = "${pkgs.systemd}/bin/systemctl";
in {
  services.swayidle = {
    enable = true;
    systemdTarget = "graphical-session.target";

    events = [
      {
        event = "lock";
        command = "${systemctl} --user start swaylock";
      }
    ];

    timeouts = [
      {
        timeout = 5 * 60;
        command = "${swaymsg} 'output * power off'";
        resumeCommand = "${swaymsg} 'output * power on'";
      }
      {
        timeout = 6 * 60;
        command = "${loginctl} lock-session";
      }
    ];
  };
}
