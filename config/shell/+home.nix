{
  imports = [
    ./fish.nix
    ./bash.nix
    ./nushell.nix
    ./starship.nix
  ];
  programs.carapace.enable = true;
}
