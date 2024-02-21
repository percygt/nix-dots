{
  pkgs,
  lib,
  profile,
  listImports,
  ...
}: let
  modules = [
    "core"
    "network"
    "hardware"
    "programs"
    "services"
    "security"
  ];
in {
  imports = [./hardware-configuration.nix] ++ listImports ../../system modules;
  hardware.opengl = {
    extraPackages = with pkgs; [
      mesa
    ];
  };
  networking = {
    inherit profile;
  };
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = lib.mkForce ["btrfs"];
  };
}
