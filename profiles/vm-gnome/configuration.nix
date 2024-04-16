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

  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
  };

  core.systemd.initrd.enable = true;
  core.net.wpa.enable = true;

  # drivers = {
  #   bluetooth.enable = true;
  #   intel.enable = true;
  #   nvidia-prime.enable = true;
  # };

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
