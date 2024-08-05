{ config, ... }:
let
  g = config._general;
in
{
  imports = [ ./dconf ];
  home-manager.users.${g.username} = import ./home.nix;
}
