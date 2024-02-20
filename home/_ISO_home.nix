{
  homeDirectory,
  stateVersion,
  flakeDirectory,
  inputs,
  lib,
  ...
}: let
  defaultShellAliases = import ../lib/aliases.nix;
  defaultSessionVariables = import ../lib/variables.nix;
in {
  imports = [
    ./.
    inputs.hyprland.homeManagerModules.default
    {wayland.windowManager.hyprland.enable = true;}
  ];
  home = {
    username = lib.mkDefault "nixos";
    homeDirectory = lib.mkDefault homeDirectory;
    stateVersion = lib.mkDefault stateVersion;
  };
  home.file.".config/autostart/foot.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Exec=foot -m fish -c 'nix_installer' 2>&1
    Hidden=false
    NoDisplay=false
    X-GNOME-Autostart-enabled=true
    Name[en_NG]=Terminal
    Name=Terminal
    Comment[en_NG]=Start Terminal On Startup
    Comment=Start Terminal On Startup
  '';

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
