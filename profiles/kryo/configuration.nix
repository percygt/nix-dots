{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: {
  imports = [
    ./disks.nix
    inputs.disko.nixosModules.disko
  ];

  core = {
    zram.enable = true;
    bootmanagement.enable = true;
    ntp.enable = true;
    storage.enable = true;
    audioengine.enable = true;
    systemd.enable = true;
    graphics.enable = true;
    packages.enable = true;
  };

  drivers = {
    bluetooth.enable = true;
    intel.enable = true;
    nvidia-prime.enable = true;
  };

  net = {
    networkmanager.enable = true;
  };

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
