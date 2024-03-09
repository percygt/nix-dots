{
  listImports,
  ...
}: let
  modules = [
    "shell/fish.nix"
    "terminal/foot.nix"
    "fonts.nix"
    "tmux.nix"
    "starship.nix"
    "yazi.nix"
    "direnv.nix"
    "nix.nix"
    "nixtools.nix"
  ];
in {
  imports = listImports ../../home modules;
}
