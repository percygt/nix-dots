{
  homeDirectory,
  pkgs,
  config,
  lib,
  username,
  ...
}: let
  backupMountPath = "/run/media/${username}/stash";
  cfg = config.infosec.backup;
in {
  options.infosec.backup = {
    enable = lib.mkEnableOption "Enable backups";
    usbId = lib.mkOption {
      description = "The bus and device id of the usb device e.g. 4-2 acquired from lsusb command 'Bus 004 Device 002'";
      default = "4-2";
      type = lib.types.string;
    };
  };
  # configured in home
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [borgbackup];
    sops.secrets."borgmatic/encryption" = {};
    services.borgmatic = {
      enable = true;
      settings = {
        repositories = [
          {
            label = "local";
            path = "${backupMountPath}/backup/data";
          }
        ];
        source_directories = [
          "${homeDirectory}/data"
        ];
        exclude_patterns = [
          "*.img"
          "*.iso"
          "*.qcow"
          ".Trash*"
        ];
        exclude_if_present = [
          ".nobackup"
        ];
        borgmatic_source_directory = "${homeDirectory}/.config/borgmatic.d";
        encryption_passcommand = "cat ${config.sops.secrets."borgmatic/encryption".path}";
        keep_daily = 7;
        before_backup = [
          "findmnt ${backupMountPath} >/dev/null || echo '${cfg.usbId}' | tee /sys/bus/usb/drivers/usb/bind || exit 75"
          "sleep 2"
        ];
        after_backup = [
          "sync"
          "sleep 300"
          "echo '${cfg.usbId}' | tee /sys/bus/usb/drivers/usb/unbind"
        ];
      };
    };
  };
}
