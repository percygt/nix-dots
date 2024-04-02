{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    {isoImage.squashfsCompression = "gzip -Xcompression-level 1";}
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
  ];

  bin.installer.enable = true; # system/bin/installer.nix

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = lib.mkForce ["btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs"];
  };

  services = {
    qemuGuest.enable = true;
    openssh.settings.PermitRootLogin = lib.mkForce "yes";
  };

  systemd = {
    services.sshd.wantedBy = pkgs.lib.mkForce ["multi-user.target"];
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };

  isoImage = {
    appendToMenuLabel = " live";
    # copy self(flake directory) to /iso path of the dot installer
    # contents = [
    #   {
    #     source = self;
    #     target = "/nix-dots";
    #   }
    # ];
  };
}
