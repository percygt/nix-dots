{ config, ... }:
let
  g = config._general;
in
{
  imports = [
    ./dconf
    ./ydotool.nix
  ];
  home-manager.users.${g.username} = import ./home.nix;
}
