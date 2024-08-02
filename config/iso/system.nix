{
  pkgs,
  lib,
  inputs,
  username,
  ...
}:
{
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
    ./installer
    ../nixpkgs
    ../nix.nix
    ../home-manager.nix
  ];

  isoImage.squashfsCompression = "gzip -Xcompression-level 1";

  home-manager.users.${username} = import ./home.nix;

  environment.systemPackages = import ../corePackages.nix pkgs;

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

  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";
}
