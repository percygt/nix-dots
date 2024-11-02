{ lib, inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./disks.nix
  ];
  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "vmd"
      "ahci"
      "nvme"
      "usb_storage"
      "usbhid"
      "uas"
      "sd_mod"
      "rtsx_usb_sdmmc"
    ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
