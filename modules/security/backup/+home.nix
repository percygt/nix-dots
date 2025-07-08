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
      "Ctrl+KP_Delete" = "exec ddapp -t 'backup' -h 90 -w 90 -- ${viewBackupLogCmd}";
      "Ctrl+Shift+KP_Delete" = "exec systemctl start borgmatic";
    };
    sops.secrets."backup/key" = { };
    services.udiskie = {
      enable = true;
      tray = "auto";
      notify = true;
      automount = true;
      settings = {
        program_options = {
          file_manager = "${pkgs.xdg-utils}/bin/xdg-open";
        };
        device_config = [
          {
            id_uuid = "cbba3a5a-81e5-4146-8895-641602b712a5";
            automount = false;
          }
          {
            id_uuid = g.security.borgmatic.mountUuid;
            keyfile = config.sops.secrets."backup/key".path;
            options = [
              "x-systemd.device-timeout=1ms" # device should be plugged already—do not wait for it
              "x-systemd.idle-timeout=5m" # unmount after 5 min of inactivity
            ];
          }
        ];
      };
    };
    systemd.user.services.udiskie.Service.ExecStartPre = "${pkgs.coreutils}/bin/sleep 15";
  };
}
