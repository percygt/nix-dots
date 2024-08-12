{ pkgs, ... }:
{
  imports = [
    ./xremap.nix
    ./bluez-suspend.nix
    ./nvd.nix
    ../home.nix
    ../apps
    ../cli
    ../dev
    ../common
    ../desktop
    ../nixpkgs/config.nix
    ../nix.nix
  ];
  home.packages = import ../corePackages.nix pkgs;
}
