{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./extensions
    ./ddterm.nix
    ./terminal.nix
    ./keybindings.nix
    ./shell.nix
  ];

  # programs.gnome-terminal.enable = true;
  home.packages = with pkgs; [
    nautilus-open-any-terminal
    gnome.dconf-editor
    gnome.gnome-terminal
  ];
  home.sessionVariables = {
    QT_QPA_PLATFORM = "xcb;wayland";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      cursor-theme = config.gtk.cursorTheme.name;
      gtk-theme = config.gtk.theme.name;
      icon-theme = config.gtk.iconTheme.name;
    };
  };
}
