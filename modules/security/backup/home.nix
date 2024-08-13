{
  lib,
  config,
  pkgs,
  libx,
  ...
}:
let
  g = config._general;
in
{
  options.modules.security.backup.enable = libx.enableDefault "backup";
  config = lib.mkIf config.modules.security.backup.enable {
    systemd.user.services.borgmatic = {
      Service = {
        Type = "exec";
        ExecStart = lib.getExe (
          pkgs.writeShellApplication {
            name = "borgmatic-exec-start";
            runtimeInputs = g.envPackages;
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
              if systemctl start nixos-rebuild.service; then
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
    home.packages = with pkgs; [ pika-backup ];
    sops.secrets."backup/key" = { };
    services.udiskie.settings.device_config = [
      {
        id_uuid = g.security.borgmatic.mountUuid;
        keyfile = config.sops.secrets."backup/key".path;
      }
    ];
  };
}
