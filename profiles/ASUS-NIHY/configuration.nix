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
    "hardware/nvidia.nix"
    "hardware/intel.nix"
    "programs"
    "services"
    "security"
  ];
in {
  imports = [./hardware-configuration.nix] ++ listImports ../../system modules;
  networking = {
    inherit profile;
  };
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = lib.mkForce ["btrfs"];
  };
}
