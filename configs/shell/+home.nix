{ pkgs, ... }:
{
  imports = [
    ./fish.nix
    ./bash.nix
    ./nushell
    ./starship.nix
    ./carapace.nix
    ./zoxide.nix
    ./eza.nix
  ];
  home.packages = [ pkgs.stable.inshellisense ];
}
