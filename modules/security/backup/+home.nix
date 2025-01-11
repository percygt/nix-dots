{
  lib,
  config,
  pkgs,
  ...
}:
let
  g = config._base;
  viewBackupLogCmd = pkgs.writers.writeBash "viewbackuplogcommand" ''
    footclient --title=BorgmaticBackup --app-id=backup -- journalctl -efo cat -u borgmatic.service
  '';
in
{
  config = lib.mkIf config.modules.security.backup.enable {
    wayland.windowManager.sway.config.keybindings = lib.mkOptionDefault {
      "Ctrl+KP_Delete" = "exec ddapp -t 'backup' -m false -h 90 -w 90 -- ${viewBackupLogCmd}";
      "Ctrl+Shift+KP_Delete" = "exec systemctl --user start borgmatic";
    };
    systemd.user.services.borgmatic = {
      Service = {
        Type = "exec";
        ExecStart = lib.getExe (
          pkgs.writeShellApplication {
            name = "borgmatic-exec-start";
            runtimeInputs = g.system.envPackages;
            text = ''
              notify_success() {
                notify-send -i emblem-default "Daily Backup" "Backup successful"
                { mpv ${pkgs.success-alert} || true; } &
                sleep 5 && kill -9 "$!"
              }
              notify_failure() {
                notify-send --urgency=critical -i emblem-error "Daily Backup" "Backup failed!"
                { mpv ${pkgs.failure-alert} || true; } &
                sleep 5 && kill -9 "$!"
              }
              if systemctl start borgmatic.service; then
                notify-send -i backup "Daily Backup" "Backup started"
                while systemctl -q is-active borgmatic.service; do
                  sleep 1
                done
                if systemctl -q is-failed borgmatic.service; then
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
    sops.secrets."backup/key" = { };
    services.udiskie.settings.device_config = [
      {
        id_uuid = g.security.borgmatic.mountUuid;
        keyfile = config.sops.secrets."backup/key".path;
      }
    ];
  };
}
