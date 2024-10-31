{ config, pkgs, ... }:
let
  g = config._general;
in
{
  imports = [
    ./xremap.nix
    ./bluez-suspend.nix
    ./nvd.nix
    ../home.nix
    ../apps
    ../cli
    ../dev
    ../shell
    ../common
    ../desktop
    ../nixpkgs/config.nix
    ../nix.nix
  ];
  home.packages = g.system.corePackages;
  nix.package = pkgs.nixVersions.latest;
}
