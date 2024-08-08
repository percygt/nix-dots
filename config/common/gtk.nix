{ config, ... }:
let
  inherit (config.modules.theme) cursorTheme iconTheme gtkTheme;
  f = config.modules.fonts.app;
in
{
  gtk = {
    enable = true;

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    font = {
      inherit (f) name size package;
    };

    cursorTheme = {
      inherit (cursorTheme) name size package;
    };

    iconTheme = {
      inherit (iconTheme) name package;
    };

    theme = {
      inherit (gtkTheme) name package;
    };

    gtk3.extraConfig = {
      "gtk-application-prefer-dark-theme" = 1;
    };
  };

  xdg = {
    configFile = {
      "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
      "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
      "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
      # "gtk-3.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-3.0/assets";
      # "gtk-3.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-3.0/gtk.css";
      # "gtk-3.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-3.0/gtk-dark.css";
    };
    dataFile = {
      "themes/${config.gtk.theme.name}".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}";
      "icons/${config.gtk.iconTheme.name}".source = "${config.gtk.iconTheme.package}/share/icons/${config.gtk.iconTheme.name}";
    };
  };

  home = {
    pointerCursor = {
      inherit (config.gtk.cursorTheme) name package size;
      gtk.enable = true;
      x11 = {
        enable = true;
        defaultCursor = config.gtk.cursorTheme.name;
      };
    };
    sessionVariables = {
      GTK_THEME = config.gtk.theme.name;
      GTK_CURSOR = config.gtk.cursorTheme.name;
      XCURSOR_THEME = config.gtk.cursorTheme.name;
      XCURSOR_SIZE = "${toString config.gtk.cursorTheme.size}";
      GTK_ICON = config.gtk.iconTheme.name;
    };
  };
}
