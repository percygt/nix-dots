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
    ../apps/home.nix
    ../cli/home.nix
    ../dev/home.nix
    ../shell/home.nix
    ../common/home.nix
    ../desktop
    ../nixpkgs/config.nix
    ../nix.nix
  ];
  home.packages = g.system.corePackages;
}
