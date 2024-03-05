{pkgs, ...}: {
  imports = [
    ./extensions
    ./ddterm.nix
    ./terminal.nix
    ./gtk.nix
    ./keybindings.nix
    ./qt.nix
    ./shell.nix
  ];

  home.packages = with pkgs; [
    nautilus-open-any-terminal
    gnome.gnome-tweaks
    gnome.dconf-editor
  ];
}
