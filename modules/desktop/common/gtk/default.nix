{
  pkgs,
  config,
  configx,
  ...
}:
let
  inherit (configx) themes;
  inherit (themes) cursorTheme iconTheme gtkTheme;
  f = config.setFonts.interface;
in
{
  gtk = {
    enable = true;

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    font = {
      inherit (f) name size;
      inherit (f) package;
    };

    cursorTheme = {
      inherit (cursorTheme) name size;
      package = cursorTheme.package pkgs;
    };

    iconTheme = {
      inherit (iconTheme) name;
      package = iconTheme.package pkgs;
    };

    theme = {
      inherit (gtkTheme) name;
      package = gtkTheme.package pkgs;
      # package = gtkTheme.package {
      #   inherit pkgs;
      #   bg = config.setTheme.colors.base00;
      #   border = config.setTheme.colors.base01;
      #   bg-dark = config.setTheme.colors.base11;
      # };
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
      "gtk-3.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-3.0/assets";
      "gtk-3.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-3.0/gtk.css";
      "gtk-3.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-3.0/gtk-dark.css";
    };
    dataFile = {
      "themes/${config.gtk.theme.name}".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}";
      "icons/${config.gtk.iconTheme.name}".source = "${config.gtk.iconTheme.package}/share/icons/${config.gtk.iconTheme.name}";
      "flatpak/overrides/global".text = ''
        [Context]
        filesystems=xdg-data/themes:ro;xdg-data/icons:ro;xdg-config/gtkrc:ro;xdg-config/gtkrc-2.0:ro;xdg-config/gtk-2.0:ro;xdg-config/gtk-3.0:ro;xdg-config/gtk-4.0:ro;/nix/store
      '';
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
      XCURSOR_SIZE = "${toString (
        builtins.floor (themes.cursorTheme.size * themes.cursorTheme.x-scaling)
      )}";
      GTK_ICON = config.gtk.iconTheme.name;
    };
  };
}
