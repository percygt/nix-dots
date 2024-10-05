{
  pkgs,
  lib,
  config,
  ...
}:
let
  systemctl = "${pkgs.systemd}/bin/systemctl";
  g = config._general;
  bak = g.security.borgmatic;
  backupMountPath = bak.mountPath;
  backupConfig = config.modules.security.backup;
in
{
  systemd.user.services.swayidle.Service.ExecStop = lib.getExe (
    pkgs.writeShellApplication {
      name = "swayidle-cleanup";
      runtimeInputs = g.system.envPackages;
      text = ''
        BLOCKFILE="$HOME/.local/share/idle-sleep-block"
        if test -f "$BLOCKFILE"; then
          rm "$BLOCKFILE"
        fi
      '';
    }
  );
  services = {
    swayidle = {
      enable = true;
      systemdTarget = "sway-session.target";
      events = [
        {
          event = "before-sleep";
          command = lib.getExe (
            pkgs.writeShellApplication {
              runtimeInputs = g.system.envPackages ++ [
                g.desktop.sway.package
                config.programs.swaylock.package
              ];
              name = "swayidle-before-sleep";
              text = ''
                swaylock --daemonize -C ${config.xdg.configHome}/swaylock/config;
                swaymsg 'output * power off'
              '';
            }
          );
        }
        {
          event = "after-resume";
          command = lib.getExe (
            pkgs.writeShellApplication {
              name = "swayidle-after-resume";
              runtimeInputs = g.system.envPackages ++ [
                g.desktop.sway.package
                pkgs.pomo
              ];
              text = ''
                if [ -f "$HOME/.local/share/pomo" ]; then pomo start || true; fi
                swaymsg 'output * power on'
              '';
            }
          );
        }
      ];

      timeouts = [
        {
          timeout = 30 * 60;
          resumeCommand = "${systemctl} --user restart kanshi";
          command = lib.getExe (
            pkgs.writeShellApplication {
              name = "swayidle-sleepy-sleep";
              runtimeInputs = g.system.envPackages ++ [
                pkgs.playerctl
                config.programs.swaylock.package
                g.desktop.sway.package
              ];
              text =
                if backupConfig.enable then
                  ''
                    set -x
                    if test -f "$HOME/.local/share/idle-sleep-block"; then
                      echo "Restarting service because of idle-sleep-block file"
                      systemctl --restart swayidle.service
                    else
                      echo "Idle timeout reached. Night night."
                      findmnt ${backupMountPath} >/dev/null || echo "${bak.usbId}" | tee /sys/bus/usb/drivers/usb/bind
                      sleep 10
                      systemctl sleep
                    fi
                  ''
                else
                  ''
                    set -x
                    if test -f "$HOME/.local/share/idle-sleep-block"; then
                      echo "Restarting service because of idle-sleep-block file"
                      systemctl --restart swayidle.service
                    else
                      echo "Idle timeout reached. Night night."
                      systemctl sleep
                    fi
                  '';
            }
          );
        }
      ];
    };
  };
}
