{
  config,
  lib,
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
    environment.persistence = {
      "/persist/system".directories = ["/var/lib/bluetooth"];
    };
  };
}
