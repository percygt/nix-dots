{
  pkgs,
  config,
  homeDirectory,
  ...
}:
let
  g = config._base;
in
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
  xdg.extraConfig.XDG_SCREENSHOTS_DIR = "${homeDirectory}/pictures/screenshots";
  gtk.gtk3 = {
    bookmarks = [
      "file:///${g.flakeDirectory}"
      "file://${homeDirectory}/.local/share"
      "file://${homeDirectory}/.config"
    ];
  };
}
