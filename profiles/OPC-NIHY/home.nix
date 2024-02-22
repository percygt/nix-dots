{
  listImports,
  flakeDirectory,
  ...
}: let
  modules = [
    "gnome"
    "neovim"
    "shell"
    "browser"
    "terminal/foot.nix"
    "scripts"
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
    hms = "home-manager switch --flake ${flakeDirectory}'?submodules=1#'home@$hostname";
  };
}
