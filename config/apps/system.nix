{ config, ... }:
let
  g = config._general;
in
{
  imports = [
    ./flatpak.nix
    ./common
    ./brave
  ];
  home-manager.users.${g.username} = import ./home.nix;
}
