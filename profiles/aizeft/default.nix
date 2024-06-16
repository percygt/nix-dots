{
  lib,
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

  cli.system.enable = true;
  dev.system.enable = true;
  terminal.system.enable = true;

  editor = {
    neovim.system.enable = true;
    emacs.system.enable = true;
    vscode.system.enable = true;
  };

  net = {
    tailscale.system.enable = true;
    syncthing.system.enable = true;
  };

  virt = {
    docker.enable = true;
    podman.enable = true;
    kvm.enable = true;
    vmvariant.enable = true;
  };

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "vmd" "ahci" "nvme" "usb_storage" "usbhid" "uas" "sd_mod" "rtsx_usb_sdmmc"];
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
