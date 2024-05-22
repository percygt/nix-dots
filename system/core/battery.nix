{
  lib,
  config,
  ...
}: {
  options.core.battery = {
    enable =
      lib.mkEnableOption "Enable battery optimization";
  };
  config = lib.mkIf config.core.battery.enable {
    boot = {
      kernelModules = ["acpi_call"];
      extraModulePackages = with config.boot.kernelPackages; [acpi_call];
    };
    services.thermald.enable = true;
    services.tlp = {
      enable = true;
      settings = {
        TLP_DEFAULT_MODE = "BAT";
        TLP_PERSISTENT_DEFAULT = 1;
        START_CHARGE_THRESH_BAT0 = 50;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
  };
}
