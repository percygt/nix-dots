{
  listImports,
  ...
}: let
  modules = [
    "nix.nix"
    "shell/fish.nix"
    "cli"
    "cli/tmux.nix"
    "cli/eza.nix"
    "cli/fzf.nix"
    "cli/bat.nix"
    "cli/starship.nix"
    "cli/yazi.nix"
    "cli/nixtools.nix"
  ];
in {
  imports = listImports ../../home modules;
}
