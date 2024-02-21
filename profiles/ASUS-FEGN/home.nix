{
  listImports,
  flakeDirectory,
  ...
}: let
  modules = [
    "gnome"
    "neovim"
    "shell"
    "terminal"
    "scripts"
    "nix.nix"
    "fonts.nix"
    "tmux.nix"
    "vscodium.nix"
    "zellij.nix"
    "starship.nix"
    "yazi.nix"
    "broot.nix"
    "direnv.nix"
    "fastfetch.nix"
    "cli.nix"
    "nixtools.nix"
    "zathura.nix"
  ];
in {
  imports = listImports ../../home modules;
  targets.genericLinux.enable = true;
  home.shellAliases = {
    hms = "home-manager switch --flake ${flakeDirectory}'?submodules=1#'home@$hostname";
  };
  home.sessionVariables = {
    QT_QPA_PLATFORM = "xcb;wayland";
    QT_STYLE_OVERRIDE = "kvantum";
    GTK_THEME = "Colloid-Dark-Nord";
    GTK_CURSOR = "Colloid-dark-cursors";
    XCURSOR_THEME = "Colloid-dark-cursors";
    GTK_ICON = "Win11";
  };
}
