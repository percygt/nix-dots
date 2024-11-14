{
  pkgs,
  config,
  lib,
  ...
}:
let
  g = config._base;
  loginctl = "${pkgs.systemd}/bin/loginctl";
  swaymsg = "${g.desktop.sway.package}/bin/swaymsg";
  swaylock = "${lib.getExe config.programs.swaylock.package}";
in
{
  services.swayidle = {
    enable = true;
    extraArgs = [ "-w" ];
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
              ${swaymsg} 'reload'
            '';
          }
        );
      }
      {
        event = "before-sleep";
        command = swaylock;
      }
      {
        event = "lock";
        command = swaylock;
      }
    ];

    timeouts = [
      {
        timeout = 15 * 60;
        command = "${swaymsg} 'output * dpms off'";
        resumeCommand = "${swaymsg} 'output * dpms on'";
      }
      {
        timeout = 45 * 60;
        command = "${loginctl} lock-session";
      }
    ];
  };
}
