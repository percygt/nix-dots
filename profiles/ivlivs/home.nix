{
  listImports,
  flakeDirectory,
  ...
}: let
  modules = [
    "_bin"
    "gnome/gtk.nix"
    "gnome/qt.nix"
    "neovim"
    "terminal/foot.nix"
    "shell"
    "fonts.nix"
    "nix.nix"
    "fonts.nix"
    "vscodium.nix"
    "cli"
    "cli/tmux.nix"
    "cli/starship.nix"
    "cli/yazi.nix"
    "cli/bat.nix"
    "cli/direnv.nix"
    "cli/eza.nix"
    "cli/fzf.nix"
    "cli/extra.nix"
    "cli/tui.nix"
    "cli/nixtools.nix"
  ];
in {
  imports = listImports ../../home modules;
  home.shellAliases = {
    hms = "home-manager switch --flake ${flakeDirectory}'?submodules=1#'$hostname";
    ns = "sudo nixos-rebuild switch --flake ${flakeDirectory}'?submodules=1#'$hostname";
  };
}
