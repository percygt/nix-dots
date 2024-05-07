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
          ".local/share/nvim"
          ".local/cache/nvim"
          ".local/state/nvim"
          ".local/share/atuin"
          ".local/share/fish"
          ".local/share/zoxide"
          ".local/share/navi"
          ".local/share/tmux/resurrect"
          ".config/keepassxc"
          ".config/BraveSoftware/Brave-Browser"
          ".config/gh"
          ".mozilla"
        ];
      };
    };
    "/persist/system" = {
      hideMounts = true;
      directories = [
        "/var/lib/systemd/coredump"
        "/var/lib/nixos"

        # "/var/lib/alsa"
        # "/var/lib/blueman"
        # "/var/lib/bluetooth"
        # "/var/lib/chrony"
        # "/var/lib/fwupd"
        "/srv"
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

  fileSystems."/persist".neededForBoot = true;

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
