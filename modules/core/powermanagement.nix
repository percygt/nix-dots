{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.core.powermanagement;
  MHz = x: x * 1000;
  p = pkgs.writeScriptBin "charge-upto" ''
    echo ''${0:-100} > /sys/class/power_supply/BAT?/charge_control_end_threshold
  '';
in
{
  config = lib.mkIf cfg.enable {
    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    environment.systemPackages = lib.mkIf cfg.enableChargeUptoScript [ p ];
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
    hardware.acpilight.enable = false;
    services = {
      acpid.enable = true;
      thermald.enable = true;
      upower = {
        enable = true;
        percentageLow = 15;
        percentageCritical = 12;
        percentageAction = 8;
        criticalPowerAction = "Suspend";
        allowRiskyCriticalPowerAction = true;
      };
      power-profiles-daemon.enable = false;
      auto-cpufreq = {
        enable = true;
        settings = {
          charger = {
            governor = "performance";
            energy_performance_preference = "performance";
            # scaling_min_freq = lib.mkDefault (MHz 1800);
            # scaling_max_freq = lib.mkDefault (MHz 3800);
            turbo = "auto";
          };
          battery = {
            governor = "powersave";
            energy_performance_preference = "power";
            scaling_min_freq = lib.mkDefault (MHz 1200);
            scaling_max_freq = lib.mkDefault (MHz 1800);
            turbo = "never";
          };
        };
      };
    };
  };
}
