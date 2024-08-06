{
  pkgs,
  config,
  lib,
  libx,
  ...
}:
let
  g = config._general;
  bak = g.backupMount;
  backupMountPath = bak.path;
  configDir = ".config/borgmatic.d";
  flagFile = "${g.homeDirectory}/${configDir}/last_run";
  cfg = config.modules.security.backup;
  beforeActions = pkgs.writeShellScriptBin "beforeActions" ''
    if [ -f "${flagFile}" ] && grep -q "$(date +%F)" "${flagFile}"; then
        ${pkgs.util-linux}/bin/findmnt ${backupMountPath} >/dev/null && echo "${bak.usbId}" | tee /sys/bus/usb/drivers/usb/unbind
        exit 75
    fi
    ${pkgs.util-linux}/bin/findmnt ${backupMountPath} >/dev/null || echo "${bak.usbId}" | tee /sys/bus/usb/drivers/usb/bind || exit 75
    sleep 60
  '';
in
{
  options.modules.security.backup = {
    enable = libx.enableDefault "backup";
  };
  # configured in home
  config = lib.mkIf cfg.enable {
    home-manager.users.${g.username} = import ./home.nix;
    environment.systemPackages = with pkgs; [ borgbackup ];
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist".users.${g.username}.directories = [ configDir ];
    };
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
        after = [
          "udisks2.service"
          "udiskie.service"
        ];
        requires = [ "udisks2.service" ];
        serviceConfig.Type = "oneshot";
        preStart = "${pkgs.coreutils}/bin/sleep 30";
        script = "${pkgs.util-linux}/bin/findmnt ${backupMountPath} >/dev/null && echo '${bak.usbId}' | tee /sys/bus/usb/drivers/usb/unbind";
      };
      timers.borgmatic = lib.mkForce {
        description = "Run borgmatic backup";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
          RandomizedDelaySec = "1h";
          OnBootSec = "15min";
        };
      };
      services.borgmatic = {
        description = "Run borgmatic backup";
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
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
          ExecStartPre = "${pkgs.coreutils}/bin/sleep 1m";
          ExecStart = "systemd-inhibit --who=\"borgmatic\" --what=\"sleep:shutdown\" --why=\"Prevent interrupting scheduled backup\" ${pkgs.borgmatic}/bin/borgmatic --verbosity -2 --syslog-verbosity 1";
        };
      };
    };
    services.borgmatic = {
      enable = true;
      settings = {
        repositories = [
          {
            label = "local";
            path = "${backupMountPath}/backup/data";
          }
        ];
        source_directories = [ "${g.homeDirectory}/data" ];
        exclude_caches = true;
        exclude_patterns = [
          "*.img"
          "*.iso"
          "*.qcow"
          "${g.dataDirectory}/.Trash-*"
        ];
        exclude_if_present = [ ".nobackup" ];
        borgmatic_source_directory = "${g.homeDirectory}/${configDir}";
        encryption_passcommand = "cat ${config.sops.secrets."borgmatic/encryption".path}";
        keep_daily = 7;
        before_actions = [ "${beforeActions}/bin/beforeActions" ];
        after_actions = [
          "sync"
          "sleep 60"
          "echo $(date +%F) > '${flagFile}'"
          "echo '${bak.usbId}' | tee /sys/bus/usb/drivers/usb/unbind"
        ];
      };
    };
  };
}
