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
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
    "${self}/modules/core/packages.nix"
    "${self}/modules/common"
    "${self}/isobldr/installer.nix"
  ];

  isoImage.squashfsCompression = "gzip -Xcompression-level 1";

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

  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";
}
