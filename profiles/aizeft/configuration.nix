{
  lib,
  username,
  ...
}: {
  imports = [
    ./disks.nix
  ];

  drivers = {
    bluetooth.enable = true;
    intel.enable = true;
    intel.gpu.driver = "xe";
    nvidia.bye = true;
  };

  net = {
    tailscale.enable = true;
    syncthing.enable = true;
  };

  environment.persistence = {
    "/persist" = {
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
        ];
        files = [
          ".local/state/tofi-drun-history"
        ];
      };
    };
  };
  boot = {
    initrd.availableKernelModules = ["xhci_pci" "vmd" "ahci" "nvme" "usb_storage" "usbhid" "uas" "sd_mod" "rtsx_usb_sdmmc"];
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
