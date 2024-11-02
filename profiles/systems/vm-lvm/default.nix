{
  pkgs,
  lib,
  inputs,
  config,
  username,
  ...
}:
{
  imports = [
    ./disks.nix
    inputs.disko.nixosModules.disko
  ];

  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
  };

  core.wpa_supplicant.enable = true;
  # symlinks to enable "erase your darlings"
  environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
    "/persist" = {
      hideMounts = true;
      users.${username} = {
        directories = [
          {
            directory = ".ssh";
            mode = "0700";
          }
          {
            directory = ".local/share/gnupg";
            mode = "0700";
          }
          {
            directory = ".local/share/keyrings";
            mode = "0700";
          }
        ];
      };
    };
    "/persist/system" = {
      hideMounts = true;
      directories = [
        "/var/lib/systemd/coredump"
        "/var/lib/nixos"
        "/var/lib/bluetooth"
        "/srv"
        "/etc/ssh"
        {
          directory = "/var/lib/colord";
          user = "colord";
          group = "colord";
          mode = "u=rwx,g=rx,o=";
        }
        {
          directory = "/var/cache/tuigreet";
          user = "greeter";
          group = "greeter";
          mode = "0755";
        }
      ];
    };
  };

  programs.fuse.userAllowOther = true;

  fileSystems."/persist".neededForBoot = true;

  boot = {
    initrd.availableKernelModules = [
      "ahci"
      "xhci_pci"
      "virtio_pci"
      "sr_mod"
      "virtio_blk"
    ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  swapDevices = [ ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
