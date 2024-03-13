{
  pkgs,
  lib,
  listImports,
  ...
}: let
  modules = [
    "core"
    "core/systemd-boot.nix"
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
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = lib.mkForce ["btrfs"];
    blacklistedKernelModules = ["hid-sensor-hub"];
    resumeDevice = "/dev/disk/by-label/NIXOS";
    efi.canTouchEfiVariables = true;
  };
}
