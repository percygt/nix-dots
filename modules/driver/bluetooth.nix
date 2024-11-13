{ config, lib, ... }:
{

  config = lib.mkIf config.modules.driver.bluetooth.enable {
    # bluetooth
    hardware.bluetooth = {
      enable = true;
      settings = {
        General = {
          Experimental = true;
          KernelExperimental = true;
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
    services.blueman.enable = true;
    modules.core.persist.systemData.directories = [ "/var/lib/bluetooth" ];
  };
}
