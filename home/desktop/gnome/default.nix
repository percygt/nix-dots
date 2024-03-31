{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    desktop.gnome.enable =
      lib.mkEnableOption "Enable Gnome DE";
  };

  imports = [
    ./extensions
    ./ddterm.nix
    ./terminal.nix
    ./keybindings.nix
    ./shell.nix
  ];

  config = lib.mkIf config.desktop.gnome.enable {
    # programs.gnome-terminal.enable = true;
    home.packages = with pkgs; [
      nautilus-open-any-terminal
      gnome.dconf-editor
      gnome.gnome-terminal
    ];
  };
}
