{ config, ... }:
let
  g = config._general;
in
{
  programs.home-manager.enable = true;

  home = {
    inherit (g) stateVersion homeDirectory;
    username = "nixos";
    shellAliases.ni = "sudo nixos-install --no-root-passwd --flake";
  };
}
