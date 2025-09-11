{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.core.powermanagement;
  p = pkgs.writeScriptBin "charge-upto" ''
    echo ''${0:-100} > /sys/class/power_supply/BAT?/charge_control_end_threshold
  '';
in
{
  config = lib.mkIf cfg.enable {
    services = {
      logind = {
        settings = {
          Login = {
            HandleLidSwitchExternalPower = "lock";
            HandlePowerKey = "suspend";
            HandleLidSwitch = "suspend";
          };
        };
      };

      power-profiles-daemon.enable = true;
      # battery info
      upower = {
        enable = true;
        percentageLow = 30;
        allowRiskyCriticalPowerAction = true;
        criticalPowerAction = "Suspend";
      };
      thermald.enable = true;
      # system76-scheduler = {
      #   enable = true;
      #   useStockConfig = true;
      # };
      ananicy = {
        enable = true;
        package = pkgs.ananicy-cpp;
        rulesProvider = pkgs.ananicy-rules-cachyos;
      };
    };
    powerManagement = {
      powerDownCommands = ''
        # Lock all sessions
        loginctl lock-sessions

        # Wait for lockscreen(s) to be up
        sleep 1
      '';
    };
    environment.systemPackages = lib.mkIf cfg.enableChargeUptoScript [
      p
    ];
    systemd.services.battery-charge-threshold = {
      wantedBy = [
        "local-fs.target"
        "suspend.target"
      ];
      after = [
        "local-fs.target"
        "suspend.target"
      ];
      description = "Set the battery charge threshold to ${toString cfg.chargeUpto}%";
      startLimitBurst = 5;
      startLimitIntervalSec = 1;
      serviceConfig = {
        Type = "oneshot";
        Restart = "on-failure";
        ExecStart = "${pkgs.runtimeShell} -c 'echo ${toString cfg.chargeUpto} > /sys/class/power_supply/BAT?/charge_control_end_threshold'";
      };
    };
  };
}
