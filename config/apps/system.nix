{ config, ... }:
let
  g = config._general;
in
{
  imports = [
    ./flatpak.nix
    ./common
    ./browsers
  ];
  home-manager.users.${g.username} = import ./home.nix;
}
