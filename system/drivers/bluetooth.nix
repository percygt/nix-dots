{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    drivers.bluetooth = {
      enable =
        lib.mkEnableOption "Enable bluetooth";
    };
  };

  config = lib.mkIf config.drivers.bluetooth.enable {
    # bluetooth
    hardware.bluetooth = {
      package = pkgs.bluez;
      enable = true;
      settings = {
        General = {
          Experimental = true;
          KernelExperimental = true;
        };
      };
    };
    services.blueman.enable = true;
    # environment.systemPackages = with pkgs; [blueberry];
    environment.persistence = {
      "/persist/system".directories = ["/var/lib/bluetooth"];
    };
  };
}
