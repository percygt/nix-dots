{ config, ... }:
let
  g = config._general;
in
{
  imports = [ ./module.nix ];
  config.home-manager.users.${g.username} = import ./module.nix;
}
