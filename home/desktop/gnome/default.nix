{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    desktop.nonNixosGnome.enable =
      lib.mkEnableOption "Enable nonNixosGnome";
  };

  imports = [
    ./extensions
    ./ddterm.nix
    ./terminal.nix
    ./keybindings.nix
    ./shell.nix
  ];

  config = lib.mkIf config.desktop.nonNixosGnome.enable {
    home.packages = with pkgs; [
      nautilus-open-any-terminal
      # gnome-extension-manager
      gnome.gnome-tweaks
      gnome.dconf-editor
    ];
  };
}
