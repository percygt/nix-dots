{
  pkgs,
  config,
  lib,
  ...
}:
let
  loginctl = "${pkgs.systemd}/bin/loginctl";
  swaymsg = "${config._general.desktop.sway.package}/bin/swaymsg";
  systemctl = "${pkgs.systemd}/bin/systemctl";
in
{
  services.swayidle = {
    enable = true;
    systemdTarget = "graphical-session.target";

    events = [
      {
        event = "after-resume";
        command = lib.getExe (
          pkgs.writeShellApplication {
            name = "swayidle-after-resume";
            runtimeInputs = [
              pkgs.coreutils
              pkgs.sway
              pkgs.pomo
            ];
            text = ''
              if [ -f "$HOME/.local/share/pomo" ]; then pomo start || true; fi
              ${pkgs.sway}/bin/swaymsg 'output * power on'
            '';
          }
        );
      }
      {
        event = "lock";
        command = "${systemctl} --user start swaylock";
      }
    ];

    timeouts = [
      {
        timeout = 15 * 60;
        command = "${swaymsg} 'output * power off'";
        resumeCommand = "${swaymsg} 'output * power on' && '${systemctl} --user restart kanshi'";
      }
      {
        timeout = 30 * 60;
        command = "${loginctl} lock-session";
      }
    ];
  };
}
