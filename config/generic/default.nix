{ pkgs, ... }:
{
  imports = [
    ./xremap.nix
    ./bluez-suspend.nix
    ./nvd.nix
    ../apps
    ../common
    ../desktop
    ../nixpkgs/config.nix
    ../nix.nix
  ];
  home.packages = import ../corePackages.nix pkgs;
}
