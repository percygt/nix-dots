{ config, ... }:
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
    ../common/home.nix
    ../desktop
    ../nixpkgs/config.nix
    ../nix.nix
  ];
  home.packages = g.system.corePackages;
}
