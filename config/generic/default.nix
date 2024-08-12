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
    ../shell
    ../common
    ../desktop
    ../nixpkgs/config.nix
    ../nix.nix
  ];
  home.packages = import ../corePackages.nix pkgs;
}
