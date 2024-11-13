{
  pkgs,
  config,
  lib,
  homeDirectory,
  ...
}:
let
  g = config._base;
  bak = g.security.borgmatic;
  backupMountPath = bak.mountPath;
  configDir = ".config/borgmatic.d";
  flagFile = "${homeDirectory}/${configDir}/last_run";
  cfg = config.modules.security.backup;
in
{
  # configured in home
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      pika-backup
      borgbackup
    ];
    modules.core.persist.userData.directories = [ configDir ];
    sops.secrets."borgmatic/encryption" = { };
    systemd = {
      timers.poweroff_hdd = {
        description = "Power-off backup hdd after automount";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          Persistent = true;
          OnBootSec = "1min";
          RandomizedDelaySec = "5min";
        };
      };
      services.poweroff_hdd = {
        description = "Power-off backup hdd after automount";
        after = [ "udisks2.service" ];
        requires = [ "udisks2.service" ];
        serviceConfig.Type = "oneshot";
        preStart = "${pkgs.coreutils-full}/bin/sleep 30";
        script = "${pkgs.util-linux}/bin/findmnt ${backupMountPath} >/dev/null && echo '${bak.usbId}' | tee /sys/bus/usb/drivers/usb/unbind &>/dev/null";
      };
      timers.borgmatic = {
        description = "Run borgmatic backup";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "Mon..Sun *-*-* 5:00:00";
          Persistent = true;
          RandomizedDelaySec = "30min";
          OnBootSec = "30min";
        };
      };
      services.borgmatic = {
        description = "Run borgmatic backup";
        after = [ "udisks2.service" ];
        requires = [ "udisks2.service" ];
        unitConfig.ConditionACPower = true;
        serviceConfig = {
          Type = "oneshot";
          LockPersonality = true;
          MemoryDenyWriteExecute = "no";
          NoNewPrivileges = "yes";
          PrivateDevices = "yes";
          PrivateTmp = "yes";
          ProtectClock = "yes";
          ProtectControlGroups = "yes";
          ProtectHostname = "yes";
          ProtectKernelLogs = "yes";
          ProtectKernelModules = "yes";
          ProtectKernelTunables = "yes";
          RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6 AF_NETLINK";
          RestrictNamespaces = "yes";
          RestrictRealtime = "yes";
          RestrictSUIDSGID = "yes";
          SystemCallArchitectures = "native";
          SystemCallFilter = "@system-service";
          SystemCallErrorNumber = "EPERM";
          ProtectSystem = "full";
          Nice = 19;
          CPUSchedulingPolicy = "batch";
          IOSchedulingClass = "best-effort";
          IOSchedulingPriority = 7;
          IOWeight = 100;
          Restart = "no";
          LogRateLimitIntervalSec = 0;
          ExecStartPre = "${pkgs.coreutils-full}/bin/sleep 1m";
          ExecStart = pkgs.writers.writeBash "borgmaticInit" ''
            systemd-inhibit \
              --who="borgmatic" \
              --what="sleep:shutdown" \
              --why="Prevent interrupting scheduled backup" \
              ${g.security.borgmatic.package}/bin/borgmatic --verbosity -2 --syslog-verbosity 1
          '';
        };
      };
    };
    services.borgmatic = {
      enable = true;
      settings = {
        repositories = [
          {
            label = "local";
            path = g.backupDirectory;
          }
        ];
        source_directories = [ g.dataDirectory ];
        exclude_caches = true;
        exclude_patterns = [
          "*.img"
          "*.iso"
          "*.qcow"
          "${g.dataDirectory}/.Trash-*"
        ];
        exclude_if_present = [ ".nobackup" ];
        borgmatic_source_directory = "${homeDirectory}/${configDir}";
        encryption_passcommand = "cat ${config.sops.secrets."borgmatic/encryption".path}";
        keep_daily = 7;
        before_backup = [
          (pkgs.writers.writeBash "beforeBackup" ''
            if [ -f "${flagFile}" ] && grep -q "$(date +%F)" "${flagFile}"; then
                ${pkgs.util-linux}/bin/findmnt ${backupMountPath} >/dev/null && echo "${bak.usbId}" | tee /sys/bus/usb/drivers/usb/unbind &>/dev/null
                exit 75
            fi
          '')
        ];

        after_backup = [
          "echo $(date +%F) > '${flagFile}'"
          "sync"
        ];

        before_actions = [
          "${pkgs.util-linux}/bin/findmnt ${backupMountPath} >/dev/null || echo '${bak.usbId}' | tee /sys/bus/usb/drivers/usb/bind &>/dev/null"
          "sleep 15"
        ];

        after_actions = [
          "sleep 15"
          "echo '${bak.usbId}' | tee /sys/bus/usb/drivers/usb/unbind &>/dev/null"
        ];
      };
    };
  };
}
