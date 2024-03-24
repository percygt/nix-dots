{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: {
  imports = [
    ./disks.nix
    inputs.disko.nixosmodules.disko
    inputs.nixos-hardware.nixosmodules.common-cpu-intel
    inputs.nixos-hardware.nixosmodules.common-gpu-nvidia-prime
    inputs.nixos-hardware.nixosmodules.common-pc
    inputs.nixos-hardware.nixosmodules.common-pc-ssd
    inputs.nixos-hardware.nixosmodules.common-hidpi
  ];

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "vmd" "ahci" "nvme" "usb_storage" "usbhid" "uas" "sd_mod" "rtsx_usb_sdmmc" "thunderbolt"];
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
