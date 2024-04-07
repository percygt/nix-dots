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
    # audioengine.enable = true;
    systemd.enable = true;
    graphics.enable = true;
    packages.enable = true;
  };

  infosec = {
    sops.enable = true;
  };

  # drivers = {
  #   bluetooth.enable = true;
  #   intel.enable = true;
  #   nvidia-prime.enable = true;
  # };

  network = {
    networkmanager.enable = true;
  };

  boot = {
    initrd.availableKernelModules = ["ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk"];
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
