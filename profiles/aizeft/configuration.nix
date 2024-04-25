{
  pkgs,
  lib,
  inputs,
  config,
  username,
  ...
}: {
  imports = [
    ./disks.nix
    inputs.disko.nixosModules.disko
    inputs.impermanence.nixosModules.impermanence
  ];

  drivers = {
    bluetooth.enable = true;
    intel.enable = true;
    nvidia-prime.enable = true;
  };

  core = {
    net.wpa.enable = true;
    battery.chargeUpto = 80;
  };

  programs.sway.extraOptions = ["--unsupported-gpu"];

  # symlinks to enable "erase your darlings"
  environment.persistence = {
    "/persist" = {
      hideMounts = true;
      users.${username} = {
        directories = [
          {
            directory = ".ssh";
            mode = "0700";
          }
          {
            directory = ".local/share/gnupg";
            mode = "0700";
          }
        ];
      };
    };
    "/persist/system" = {
      hideMounts = true;
      directories = [
        "/var/lib/systemd/coredump"
        "/var/lib/nixos"
        "/var/lib/flatpak"
        "/var/lib/bluetooth"
        "/srv"
        "/etc/ssh"
        {
          directory = "/var/lib/colord";
          user = "colord";
          group = "colord";
          mode = "u=rwx,g=rx,o=";
        }
        {
          directory = "/var/cache/tuigreet";
          user = "greeter";
          group = "greeter";
          mode = "0755";
        }
      ];
      files = [
        "/etc/machine-id"
      ];
    };
  };

  programs.fuse.userAllowOther = true;

  fileSystems."/persist".neededForBoot = true;

  # environment.sessionVariables = {
  #   WLR_DRM_NO_ATOMIC = "1";
  #   WLR_NO_HARDWARE_CURSORS = "1";
  #   LIBVA_DRIVER_NAME = "nvidia";
  #   MOZ_DISABLE_RDD_SANDBOX = "1";
  #   EGL_PLATFORM = "wayland";
  # };

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "vmd" "ahci" "nvme" "usb_storage" "usbhid" "uas" "sd_mod" "rtsx_usb_sdmmc"];
    initrd.kernelModules = [];
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  swapDevices = [];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
