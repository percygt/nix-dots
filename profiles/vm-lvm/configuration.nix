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

  core.systemd.initrd.enable = true;
  core.net.wpa.enable = true;
  # symlinks to enable "erase your darlings"
  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
      "/var/lib/systemd/coredump"
      "/var/lib/nixos"
      "/var/lib/bluetooth"
      "/srv"
      "/etc/ssh"
      # "/etc/NetworkManager/system-connections"
      # "/var/lib/bluetooth"
      # # "/var/lib/docker"
      # "/var/lib/power-profiles-daemon"
      # # "/var/lib/tailscale"
      # "/var/lib/upower"
      # "/var/lib/systemd/coredump"
      {
        directory = "/var/lib/colord";
        user = "colord";
        group = "colord";
        mode = "u=rwx,g=rx,o=";
      }
    ];
    # files = [
    #   "/var/lib/NetworkManager/secret_key"
    #   "/var/lib/NetworkManager/seen-bssids"
    #   "/var/lib/NetworkManager/timestamps"
    # ];
  };
  # environment.etc.machine-id.source = "/persist/system/etc/machine-id";

  # system.activationScripts.persistent-dirs.text = let
  #   mkHomePersist = user:
  #     lib.optionalString user.createHome ''
  #       mkdir -p /persist/${user.home}
  #       chown ${user.name}:${user.group} /persist/${user.home}
  #       chmod ${user.homeMode} /persist/${user.home}
  #     '';
  #   users = lib.attrValues config.users.users;
  # in
  #   lib.concatLines (map mkHomePersist users);

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
