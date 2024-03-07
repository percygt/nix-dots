{
  pkgs,
  lib,
  profile,
  listImports,
  ...
}: let
  modules = [
    "core"
    "core/grub.nix"
    "network"
    "hardware"
    "hardware/intel.nix"
    "programs"
    "services"
    "security"
  ];
in {
  imports = listImports ../../system modules;
  networking = {
    hostName = profile;
  };
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = lib.mkForce ["btrfs"];
  };
}
