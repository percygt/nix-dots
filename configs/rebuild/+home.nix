{
  config,
  pkgs,
  lib,
  ...
}:
let
  g = config._base;
  viewRebuildLogCmd = pkgs.writers.writeBash "viewrebuildlogcommand" ''
    footclient --title=NixosRebuild --app-id=system-software-update -- journalctl -efo cat -u nixos-rebuild.service
  '';
in
{
  wayland.windowManager.sway.config.keybindings = lib.mkOptionDefault {
    "Ctrl+KP_Insert" =
      "exec ddapp -t 'system-software-update' -m false -h 90 -w 90 -- ${viewRebuildLogCmd}";
    "Ctrl+Shift+KP_Insert" = "exec systemctl --user start nixos-rebuild";
  };
  systemd.user.services.nixos-rebuild = {
    Service = {
      Type = "exec";
      X-RestartIfChanged = "false";
      ExecStart = lib.getExe (
        pkgs.writeShellApplication {
          name = "nixos-rebuild-exec-start";
          runtimeInputs = g.system.envPackages;
          text = ''
            notify_success() {
              notify-send -i emblem-default "System Rebuild" "NixOS rebuild successful"
              { mpv ${pkgs.success-alert} || true; } &
              sleep 5 && kill -9 "$!"
            }
            notify_failure() {
              notify-send --urgency=critical -i emblem-error "System Rebuild" "NixOS rebuild failed!"
              { mpv ${pkgs.failure-alert} || true; } &
              sleep 5 && kill -9 "$!"
            }
            if systemctl start nixos-rebuild.service; then
              notify-send -i zen-icon "System Rebuild" "NixOS rebuild switch started"
              while systemctl -q is-active nixos-rebuild.service; do
                sleep 1
              done
              if systemctl -q is-failed nixos-rebuild.service; then
                notify_failure
              else
                notify_success
              fi
            else
              notify_failure
            fi
          '';
        }
      );
    };
  };
}
