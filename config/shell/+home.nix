{
  imports = [
    ./fish.nix
    ./bash.nix
    ./nushell
    ./atuin.nix
    ./starship.nix
  ];
  programs.carapace.enable = true;
}
