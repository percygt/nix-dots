{
  config,
  lib,
  ...
}: {
  options = {
    drivers.nvidia-prime = {
      enable =
        lib.mkEnableOption "Enable nvidia gpu";
    };
  };

  config = lib.mkIf config.drivers.nvidia-prime.enable {
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      prime = {
        offload.enable = true;
        offload.enableOffloadCmd = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:2:0:0";
      };

      modesetting.enable = true;

      powerManagement = {
        enable = true;
        finegrained = true;
      };

      open = true;
      nvidiaSettings = false; # gui app
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
  };
}
