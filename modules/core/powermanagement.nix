{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.core.powermanagement;
  MHz = x: x * 1000;
in
{
  config = lib.mkIf cfg.enable {
    hardware.acpilight.enable = false;
    services = {
      acpid.enable = true;
      thermald.enable = true;
      auto-cpufreq = {
        enable = true;
        settings = {
          charger = {
            governor = "performance";
            energy_performance_preference = "performance";
            scaling_min_freq = lib.mkDefault (MHz 1800);
            scaling_max_freq = lib.mkDefault (MHz 3800);
            turbo = "auto";
          };
          battery = {
            governor = "powersave";
            energy_performance_preference = "power";
            scaling_min_freq = lib.mkDefault (MHz 1200);
            scaling_max_freq = lib.mkDefault (MHz 1800);
            turbo = "never";
            enable_thresholds = true;
            start_threshold = 40;
            stop_threshold = 80;
          };
        };
      };
    };
  };
}
