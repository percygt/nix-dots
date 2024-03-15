{
  listImports,
  ...
}: let
  modules = [
    "shell/fish.nix"
    "tmux.nix"
    "starship.nix"
    "yazi.nix"
    "nix.nix"
    "nixtools.nix"
  ];
in {
  imports = listImports ../../home modules;
}
