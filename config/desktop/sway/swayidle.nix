{
  pkgs,
  config,
  lib,
  ...
}:
let
  g = config._general;
  loginctl = "${pkgs.systemd}/bin/loginctl";
  swaymsg = "${g.desktop.sway.package}/bin/swaymsg";
  swaylock = "${lib.getExe config.programs.swaylock.package}";
in
{
  services.swayidle = {
    enable = true;
    systemdTarget = "sway-session.target";
    events = [
      {
        event = "after-resume";
        command = lib.getExe (
          pkgs.writeShellApplication {
            name = "swayidle-after-resume";
            runtimeInputs = g.system.envPackages ++ [
              pkgs.pomo
              g.desktop.sway.package
            ];
            text = ''
              if [ -f "$HOME/.local/share/pomo" ]; then pomo start || true; fi
              ${swaymsg} 'output * power on'
            '';
          }
        );
      }
      {
        event = "lock";
        command = "${swaylock} --daemonize -C ${config.xdg.configHome}/swaylock/config";
      }
    ];

    timeouts = [
      {
        timeout = 15 * 60;
        command = "${swaymsg} 'output * power off'";
        resumeCommand = "${swaymsg} 'output * power on' && '${swaymsg} reload'";
      }
      {
        timeout = 45 * 60;
        command = "${loginctl} lock-session";
      }
    ];
  };
}
