{
  pkgs,
  lib,
  inputs,
  self,
  ...
}: {
  imports = [
    {isoImage.squashfsCompression = "gzip -Xcompression-level 1";}
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
    "${self}/system/core/packages.nix"
    "${self}/system/common"
    "${self}/system/bin/installer.nix"
  ];

  core.packages.enable = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = lib.mkForce ["btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs"];
  };

  services = {
    spice-vdagentd.enable = true;
    qemuGuest.enable = true;
    udisks2.enable = true;
    openssh.settings.PermitRootLogin = lib.mkForce "yes";
  };
}
