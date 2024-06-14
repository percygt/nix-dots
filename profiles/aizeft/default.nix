{
  lib,
  username,
  inputs,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
    ./disks.nix
  ];

  drivers = {
    adb.enable = true;
    bluetooth.enable = true;
    intel.enable = true;
    intel.gpu.driver = "xe";
    nvidia.bye = true;
  };

  dev.enable = true;

  terminal = {
    wezterm.enable = true;
    kitty.enable = true;
  };
  infosec = {
    common.enable = true;
    pass.enable = true;
    keepass.enable = true;
  };

  cli.system.enable = true;

  editor = {
    neovim.system.enable = true;
    emacs.system.enable = true;
    vscode.system.enable = true;
  };
  net = {
    tailscale.enable = true;
    syncthing.enable = true;
  };

  environment.persistence = {
    "/persist" = {
      users.${username} = {
        directories = [
          ".local/share/aria2"
          ".local/share/Mumble"
          ".local/share/atuin"
          ".local/share/keyrings"
          ".local/share/fish"
          ".local/share/zoxide"
          ".local/share/navi"
          ".local/share/tmux/resurrect"
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
