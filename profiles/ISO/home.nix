{
  listImports,
  ...
}: let
  modules = [
    "gnome"
    "neovim"
    "shell/fish.nix"
    "terminal/foot.nix"
    "fonts.nix"
    "tmux.nix"
    "starship.nix"
    "yazi.nix"
    "direnv.nix"
  ];
in {
  imports = listImports ../../home modules;
}
