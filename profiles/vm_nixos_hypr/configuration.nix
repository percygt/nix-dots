{
  pkgs,
  lib,
  listImports,
  ...
}: let
  modules = [
    "core"
    "core/grub.nix"
    "network"
    "hardware"
    "hardware/intel.nix"
    "programs/hyprland.nix"
    "programs/cli.nix"
    "programs/xdg.nix"
    "services"
    "security"
  ];
in {
  imports =
    [
      ./disks.nix
      ./hardware-configuration.nix
    ]
    ++ listImports ../../system modules;
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = lib.mkForce ["btrfs"];
    loader.grub.efiInstallAsRemovable = lib.mkForce true; # true if nvram is not persistent like in vms
  };
}
