{ config, ... }:
let
  g = config._general;
in
{
  programs.home-manager.enable = true;

  _general.username = "nixos";
  home = {
    inherit (g) stateVersion homeDirectory username;
    shellAliases.ni = "sudo nixos-install --no-root-passwd --flake";
  };
}
