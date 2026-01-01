{
  config,
  lib,
  pkgs,
  ...
}:
{

  config = lib.mkIf config.modules.drivers.bluetooth.enable {
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
          FastConnectable = true;
        };
      };
    };
    hardware.enableAllFirmware = true;
    services.blueman.enable = true;
    persistSystem.directories = [ "/var/lib/bluetooth" ];
  };
}
