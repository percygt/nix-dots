{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.modules.drivers = {
    nvidia = {
      prime.enable = lib.mkEnableOption "Enable nvidia-prime";
      bye = lib.mkOption {
        description = "Disable nvidia gpu";
        default = false;
        type = lib.types.bool;
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.drivers.nvidia.prime.enable {
      boot.kernelParams = [
        "mem_sleep_default=deep"
        "nouveau.modeset=0"
        "ipv6.disable=1"
      ]; # Oddly, ipv6 was horribly buggy and causing problems for me in other areas
      boot.blacklistedKernelModules = [
        "nouveau"
        "bbswitch"
        "nvidiafb"
      ];
      services.xserver.videoDrivers = [ "nvidia" ];
      systemd.services.supergfxd.path = [ pkgs.pciutils ];
      services = {
        supergfxd = {
          enable = true;
          settings = {
            mode = "Hybrid";
            vfio_enable = false;
            vfio_save = false;
            always_reboot = false;
            no_logind = false;
            logout_timeout_s = 180;
          };
        };
      };

      hardware.graphics.extraPackages = [
        (if pkgs ? libva-vdpau-driver then pkgs.libva-vdpau-driver else pkgs.vaapiVdpau)
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
    })
    (lib.mkIf config.modules.drivers.nvidia.bye {
      boot.extraModprobeConfig = ''
        blacklist nouveau
        options nouveau modeset=0
      '';

      services.udev.extraRules = ''
        # Remove NVIDIA USB xHCI Host Controller devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"

        # Remove NVIDIA USB Type-C UCSI devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"

        # Remove NVIDIA Audio devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"

        # Remove NVIDIA VGA/3D controller devices
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
      '';
      boot.blacklistedKernelModules = [
        "nouveau"
        "nvidia"
        "nvidia_drm"
        "nvidia_modeset"
      ];
    })
  ];
}
