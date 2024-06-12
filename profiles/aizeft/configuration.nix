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
    bluetooth.enable = true;
    intel.enable = true;
    intel.gpu.driver = "xe";
    nvidia.bye = true;
  };

  net = {
    tailscale.enable = true;
    syncthing.enable = true;
  };

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "vmd" "ahci" "nvme" "usb_storage" "usbhid" "uas" "sd_mod" "rtsx_usb_sdmmc"];
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
