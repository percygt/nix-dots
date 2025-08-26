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
    # boot.kernelParams = [ "intel_pstate=disable" ];
    powerManagement.cpuFreqGovernor = "powersave";
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
    services = {
      thermald.enable = true;
      upower.enable = lib.mkDefault true;
      system76-scheduler = {
        enable = true;
        useStockConfig = true;
      };
      auto-cpufreq = {
        enable = true;
        settings = {
          charger = {
            governor = "performance";
            energy_performance_preference = "performance";
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
