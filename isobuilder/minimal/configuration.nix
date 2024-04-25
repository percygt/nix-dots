{
  pkgs,
  lib,
  inputs,
  self,
  username,
  homeArgs,
  outputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    {isoImage.squashfsCompression = "gzip -Xcompression-level 1";}
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
    "${self}/system/core/packages.nix"
    "${self}/system/common"
    ../installer.nix
  ];

  home-manager = {
    users.${username} = import ./home.nix;
    extraSpecialArgs = homeArgs;
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  core.packages.enable = true;

  nixpkgs.overlays = builtins.attrValues outputs.overlays;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = lib.mkForce ["btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs"];

  services = {
    udisks2.enable = true;
    openssh.settings.PermitRootLogin = lib.mkForce "yes";
  };
}
