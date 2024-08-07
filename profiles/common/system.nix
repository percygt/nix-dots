{ config, libx, ... }:
let
  g = config._general;
in
{
  imports = libx.importPaths.moduleAll ./.;
  home-manager.users.${g.username} = import ./home.nix;
}
