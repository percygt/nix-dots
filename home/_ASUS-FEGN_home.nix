{
  username,
  homeDirectory,
  stateVersion,
  flakeDirectory,
  ...
}: let
  defaultShellAliases = import ../lib/aliases.nix;
  defaultSessionVariables = import ../lib/variables.nix;
in {
  imports = [
    ./.
    ./gnome
    ./fonts.nix
    ./nix.nix
  ];
  news.display = "silent";
  targets.genericLinux.enable = true;
  home = {
    inherit
      username
      homeDirectory
      stateVersion
      ;
  };
  home.shellAliases =
    defaultShellAliases
    // {
      hms = "home-manager switch --flake ${flakeDirectory}'?submodules=1#'home@$hostname";
    };
  home.sessionVariables =
    defaultSessionVariables
    // {
      FLAKE_PATH = flakeDirectory;
      QT_QPA_PLATFORM = "xcb;wayland";
      QT_STYLE_OVERRIDE = "kvantum";
      GTK_THEME = "Colloid-Dark-Nord";
      GTK_CURSOR = "Colloid-dark-cursors";
      XCURSOR_THEME = "Colloid-dark-cursors";
      GTK_ICON = "Win11";
    };
}
