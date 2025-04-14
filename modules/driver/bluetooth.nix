{
  config,
  lib,
  pkgs,
  ...
}:
{

  config = lib.mkIf config.modules.driver.bluetooth.enable {
    # bluetooth
    hardware.bluetooth = {
      enable = true;
      package = pkgs.bluez5-experimental;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
          KernelExperimental = true;
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
    hardware.enableAllFirmware = true;
    services.blueman.enable = true;
    modules.core.persist.systemData.directories = [ "/var/lib/bluetooth" ];
  };
}
