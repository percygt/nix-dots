{
  listImports,
  flakeDirectory,
  ...
}: let
  modules = [
    "gnome"
    "neovim"
    "shell"
    "terminal/foot.nix"
    "fonts.nix"
    "tmux.nix"
    "starship.nix"
    "yazi.nix"
    "direnv.nix"
    "cli.nix"
    "nixtools.nix"
  ];
in {
  imports = listImports ../../home modules;
  home.shellAliases = {
    hms = "home-manager switch --flake ${flakeDirectory}'?submodules=1#'$hostname";
    ns = "sudo nixos-rebuild switch --flake ${flakeDirectory}'?submodules=1#'$hostname";
  };
}
