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
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist/system".directories = [ "/var/lib/bluetooth" ];
    };
  };
}
