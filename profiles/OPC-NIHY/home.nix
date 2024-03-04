{
  listImports,
  flakeDirectory,
  ...
}: let
  modules = [
    "_bin"
    "gnome"
    "neovim"
    "shell"
    "browser"
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
    hms = "home-manager switch --flake ${flakeDirectory}'?submodules=1#'home@$hostname";
  };
}
