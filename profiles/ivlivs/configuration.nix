{
  pkgs,
  lib,
  listImports,
  inputs,
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
  imports =
    listImports ../../system modules
    ++ [
      inputs.home-manager.nixosModules.default
      ./hardware.nix
    ];
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = lib.mkForce ["btrfs"];
    blacklistedKernelModules = ["hid-sensor-hub"];
    resumeDevice = "/dev/disk/by-label/NIXOS";
    efi.canTouchEfiVariables = true;
  };
}
