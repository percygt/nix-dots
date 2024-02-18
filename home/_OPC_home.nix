{
  username,
  homeDirectory,
  stateVersion,
  flakeDirectory,
  inputs,
  ...
}: let
  defaultShellAliases = import ../lib/aliases.nix;
  defaultSessionVariables = import ../lib/variables.nix;
in {
  imports = [
    ./.
    ./nix.nix
    inputs.hyprland.homeManagerModules.default
    {wayland.windowManager.hyprland.enable = true;}
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
      hms = "home-manager switch --flake ${flakeDirectory}'?submodules=1#'$hostname";
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
