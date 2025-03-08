{
  config,
  lib,
  # pkgs,
  ...
}:
let
  cfg = config.modules.core.powermanagement;
in
{
  config = lib.mkIf cfg.enable {
    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    powerManagement.powertop.enable = true;
    services = {
      thermald.enable = true;
      power-profiles-daemon.enable = false;
      system76-scheduler.enable = true;
      tlp = {
        enable = true;
        settings = {
          # sudo tlp-stat or tlp-stat -s or sudo tlp-stat -p
          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 0;
          CPU_HWP_DYN_BOOST_ON_AC = 1;
          CPU_HWP_DYN_BOOST_ON_BAT = 0;
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
          START_CHARGE_THRESH_BAT0 = 75;
          STOP_CHARGE_THRESH_BAT0 = 81;
          USB_AUTOSUSPEND = 0;
          USB_EXCLUDE_BTUSB = 1;
          USB_EXCLUDE_PHONE = 1;
        };
      };
    };
  };
}
