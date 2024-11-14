{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
let
  g = config._base;
in
{
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
    ./installer.nix
    ../nixpkgs
    ../nix.nix
    ../home-manager.nix
  ];
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
  environment.systemPackages = g.system.corePackages;
  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = lib.mkForce [
    "btrfs"
    "reiserfs"
    "vfat"
    "f2fs"
    "xfs"
    "ntfs"
    "cifs"
  ];
}
