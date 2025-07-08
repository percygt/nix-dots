{ pkgs, ... }:
{
  imports = [
    ./extensions
    ./ddterm.nix
    ./terminal.nix
    ./keybindings.nix
    ./dconf.nix
  ];

  # programs.gnome-terminal.enable = true;
  home.packages = with pkgs; [
    nautilus-open-any-terminal
    dconf-editor
    gnome-terminal
  ];
  home.sessionVariables = {
    QT_QPA_PLATFORM = "xcb;wayland";
  };
}
