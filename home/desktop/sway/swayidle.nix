{
  pkgs,
  config,
  ...
}: let
  loginctl = "${pkgs.systemd}/bin/loginctl";
  swaymsg = "${config.wayland.windowManager.sway.package}/bin/swaymsg";
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
        timeout = 15 * 60;
        command = "${swaymsg} 'output * power off'";
        resumeCommand = "${swaymsg} 'output * power on'";
      }
      {
        timeout = 30 * 60;
        command = "${loginctl} lock-session";
      }
    ];
  };
}
