{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
let
  g = config._general;
in
{
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
    ./installer.nix
    ../nixpkgs
    ../nix.nix
    ../home-manager.nix
  ];
  _general.username = "nixos";
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
  home-manager.users.${g.username} = import ./home.nix;
  environment.systemPackages = import ../corePackages.nix pkgs;
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
