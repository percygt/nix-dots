{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.graphics.nvidia;
in
{
  config = lib.mkMerge [
    (lib.mkIf cfg.prime.enable {
      boot.kernelParams = [
        "mem_sleep_default=deep"
        "nouveau.modeset=0"
      ];
      boot.blacklistedKernelModules = [
        "nouveau"
        "bbswitch"
        "nvidiafb"
      ];
      environment.systemPackages = with pkgs; [
        vdpauinfo
      ];
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware = {
        graphics = {
          enable = true;
          enable32Bit = true;
          extraPackages = [
            pkgs.vaapiVdpau
          ];
        };
        nvidia = {
          prime = {
            inherit (cfg.prime)
              intelBusId
              nvidiaBusId
              ;
          };
          modesetting.enable = true;
          open = false;
          package = config.boot.kernelPackages.nvidiaPackages.latest;
        };
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
    (lib.mkIf (cfg.prime.enable && cfg.prime.batterySaverSpecialisation) {
      specialisation = {
        battery-saver.configuration = {
          system.nixos.tags = [ "battery-saver" ];
          modules.graphics.nvidia.bye = true;
          hardware.nvidia = {
            prime.offload.enable = lib.mkForce false;
            powerManagement = {
              enable = lib.mkForce false;
              finegrained = lib.mkForce false;
            };
          };
        };
      };
    })
    (lib.mkIf cfg.bye {
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
