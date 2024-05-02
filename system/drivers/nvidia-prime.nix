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
        sync.enable = false;
        offload.enable = true;
        offload.enableOffloadCmd = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:2:0:0";
      };

      modesetting.enable = true;

      powerManagement = {
        enable = false;
        finegrained = false;
      };

      open = false;
      nvidiaSettings = true; # gui app
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
    environment.variables = {
      # Required to run the correct GBM backend for nvidia GPUs on wayland
      GBM_BACKEND = "nvidia-drm";
      # Apparently, without this nouveau may attempt to be used instead
      # (despite it being blacklisted)
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      # Hardware cursors are currently broken on nvidia
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  };
}
