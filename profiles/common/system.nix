{ config, ... }:
let
  g = config._general;
in
{
  imports = [
    ./fonts.nix
    ./theme.nix
  ];

  home-manager.users.${g.username} = import ./home.nix;
}
