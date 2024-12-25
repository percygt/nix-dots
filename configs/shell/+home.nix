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
    ./eza.nix
  ];
  home.packages = [ pkgs.stable.inshellisense ];
}
