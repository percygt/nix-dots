{
  config,
  lib,
  pkgs,
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

    services.supergfxd = {
      enable = true;
      settings = {
        mode = "Hybrid";
        vfio_enable = false;
        vfio_save = false;
        always_reboot = false;
        no_logind = false;
        logout_timeout_s = 180;
        hotplug_type = "Asus";
      };
    };

    hardware.opengl.extraPackages = with pkgs; [
      vaapiVdpau
    ];

    hardware.nvidia = {
      prime = {
        sync.enable = true;
        offload.enable = false;
        offload.enableOffloadCmd = false;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:2:0:0";
      };

      modesetting.enable = true;

      powerManagement = {
        enable = false;
        finegrained = false;
      };

      open = true;
      nvidiaSettings = false; # gui app
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
  };
}
