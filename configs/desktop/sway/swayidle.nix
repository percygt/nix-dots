{
  pkgs,
  config,
  lib,
  ...
}:
let
  g = config._base;
  swaymsg = "${g.desktop.sway.finalPackage}/bin/swaymsg";
  swaylock = "${lib.getExe config.programs.swaylock.package}";
  loginctl = "${pkgs.systemd}/bin/loginctl";
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
              g.desktop.sway.finalPackage
            ];
            text = ''
              if [ -f "$HOME/.local/share/pomo" ]; then pomo start || true; fi
              ${swaymsg} 'output * power on'
              ${swaymsg} 'reload'
            '';
          }
        );
      }
      {
        event = "lock";
        command = "swaylock --grace 0";
      }
      {
        event = "unlock";
        command = "pkill -SIGUSR1 swaylock";
      }
      {
        event = "before-sleep";
        command = swaylock;
      }
    ];

    timeouts = [
      {
        timeout = 30 * 60;
        command = "${swaymsg} 'output * power off'";
        resumeCommand = "${swaymsg} 'output * power on'";
      }
      {
        timeout = 15 * 60;
        command = "${loginctl} lock-session";
      }
    ];
  };
}
