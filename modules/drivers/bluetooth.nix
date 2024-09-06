{ config, lib, ... }:
{
  options.modules.drivers.bluetooth.enable = lib.mkEnableOption "Enable bluetooth";

  config = lib.mkIf config.modules.drivers.bluetooth.enable {
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
    # environment.systemPackages = with pkgs; [blueberry];
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist/system".directories = [ "/var/lib/bluetooth" ];
    };
  };
}
