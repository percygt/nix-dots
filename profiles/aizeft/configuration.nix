{
  lib,
  config,
  username,
  ...
}: {
  imports = [
    ./disks.nix
  ];

  drivers = {
    bluetooth.enable = true;
    intel.enable = true;
    nvidia-prime.enable = true;
  };

  net = {
    tailscale.enable = true;
    syncthing.enable = true;
  };

  # symlinks to enable "erase your darlings"
  environment.persistence = {
    "/persist" = {
      hideMounts = true;
      users.${username} = {
        directories = [
          ".local/state/nvim"
          ".local/share/nvim"
          ".local/share/aria2"
          ".local/share/Mumble"
          ".local/share/atuin"
          ".local/share/keyrings"
          ".local/share/fish"
          ".local/share/zoxide"
          ".local/share/navi"
          ".local/share/tmux/resurrect"
          ".local/cache/nvim"
          ".local/cache/nix-index"
          ".local/cache/amberol"
          ".config/goa-1.0"
          ".config/keepassxc"
          ".config/BraveSoftware/Brave-Browser"
          ".config/gh"
          ".config/Mumble"
          ".mozilla"
        ];
        files = [
          ".local/state/tofi-drun-history"
        ];
      };
    };
    "/persist/system" = {
      hideMounts = true;
      directories = [
        "/var/lib/systemd/coredump"
        "/var/lib/nixos"
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
    kernelModules = ["kvm-intel" "intel_agp"];
    extraModulePackages = [];
  };

  swapDevices = [];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
