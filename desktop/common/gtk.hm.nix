{ config, lib, ... }:
let
  inherit (config.modules.themes)
    cursorTheme
    iconTheme
    gtkTheme
    ;

  g = config._global;
  f = config.modules.fonts.app;
  srcTheme = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}";
  gtk4SrcTheme = "${srcTheme}/gtk-4.0";
in
{
  dconf.settings = import ./__dconf.nix { inherit config lib; };
  gtk = {
    enable = true;
    gtk2.configLocation = "${g.xdg.configHome}/gtk-2.0/gtkrc";
    font = { inherit (f) name size package; };
    cursorTheme = { inherit (cursorTheme) name size package; };
    iconTheme = { inherit (iconTheme) name package; };
    theme = { inherit (gtkTheme) name package; };
    gtk3.extraConfig."gtk-application-prefer-dark-theme" = 1;
  };
  xdg = {
    configFile = {
      "gtk-4.0/assets".source = "${gtk4SrcTheme}/assets";
      "gtk-4.0/gtk.css".source = "${gtk4SrcTheme}/gtk.css";
      "gtk-4.0/gtk-dark.css".source = "${gtk4SrcTheme}/gtk-dark.css";
    };
    dataFile = {
      "themes/${config.gtk.theme.name}".source = srcTheme;
      "icons/${config.gtk.iconTheme.name}".source =
        "${config.gtk.iconTheme.package}/share/icons/${config.gtk.iconTheme.name}";
    };
  };
  home = {
    pointerCursor = {
      inherit (config.gtk.cursorTheme) name package size;
      gtk.enable = true;
      x11.enable = true;
      x11.defaultCursor = config.gtk.cursorTheme.name;
    };
  };
}
