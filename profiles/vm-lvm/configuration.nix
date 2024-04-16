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
    inputs.impermanence.nixosModules.impermanence
  ];

  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
  };

  core = {
    ephemeral.enable = true;
    zram.enable = true;
    bootmanagement.enable = true;
    ntp.enable = true;
    storage.enable = true;
    audioengine.enable = true;
    systemd.enable = true;
    graphics.enable = true;
    packages.enable = true;
  };

  net = {
    networkmanager.enable = true;
  };

  # symlinks to enable "erase your darlings"
  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
      # "/var/keys"
      # "/etc/NetworkManager/system-connections"
      # "/var/lib/bluetooth"
      # "/var/lib/docker"
      # "/var/lib/power-profiles-daemon"
      # "/var/lib/tailscale"
      # "/var/lib/upower"
      # "/var/lib/systemd/coredump"
      # {
      #   directory = "/var/lib/colord";
      #   user = "colord";
      #   group = "colord";
      #   mode = "u=rwx,g=rx,o=";
      # }
    ];
    files = [
      {
        file = "/var/keys/data.keyfile";
        parentDirectory = {mode = "u=rwx,g=,o=";};
      }
      {
        file = "/var/keys/system-sops.keyfile";
        parentDirectory = {mode = "u=rwx,g=,o=";};
      }
      # "/var/lib/NetworkManager/secret_key"
      # "/var/lib/NetworkManager/seen-bssids"
      # "/var/lib/NetworkManager/timestamps"
    ];
  };

  programs.fuse.userAllowOther = true;

  fileSystems."/persist".neededForBoot = true;

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
