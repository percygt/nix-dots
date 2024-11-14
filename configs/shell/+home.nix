{ pkgs, ... }:
{
  imports = [
    ./fish.nix
    ./bash.nix
    ./nushell
    ./atuin.nix
    ./starship.nix
    ./carapace.nix
    ./zoxide.nix
  ];
  home.packages = [ pkgs.inshellisense ];
}
