{pkgs, ...}: {
  imports = [
    ./extensions
    ./ddterm.nix
    ./terminal.nix
    ./keybindings.nix
    ./shell.nix
  ];
  home.packages = with pkgs; [
    nautilus-open-any-terminal
    gnome-extension-manager
    gnome.gnome-tweaks
    gnome.dconf-editor
  ];
}
