{ lib, pkgs, ... }:
{
  imports = [
    ./xremap.nix
    ./bluez-suspend.nix
    ./nvd.nix
    ../nixpkgs/config.nix
    ../nix.nix
  ];
  home.packages = import ../packages.nix pkgs;
}
