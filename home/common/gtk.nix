{
  pkgs,
  config,
  username,
  lib,
  flakeDirectory,
  self,
  ...
}: let
  inherit (import "${self}/lib/mkUI.nix" {inherit pkgs config;}) themes fonts;
  HOME_THEMES = "${config.home.homeDirectory}/.themes";
in {
  xdg.dataFile = {
    backgrounds = {
      source = "${self}/lib/assets/backgrounds";
    };
  };
  gtk = {
    enable = true;
    theme = themes.gtkTheme;
    font = fonts.ui;
    inherit (themes) cursorTheme iconTheme;
    gtk3 = {
      bookmarks = [
        "file:///${flakeDirectory}"
        "file:///home/${username}/.local"
        "file:///home/${username}/.config"
        "file:///windows"
        "file:///backup"
        "file:///data/playground"
        "file:///data/git-repo"
        "file:///data/logs"
        "file:///data/codebox"
        "file:///data/distrobox"
        "file:///data"
        "file:///home/${username}/Documents"
        "file:///home/${username}/Music"
        "file:///home/${username}/Pictures"
        "file:///home/${username}/Videos"
        "file:///home/${username}/Downloads"
      ];
    };
  };

  home = {
    packages = with pkgs; [
      ffmpegthumbnailer
    ];
    activation = {
      cpGtkThemeIfDoesNotExist = lib.hm.dag.entryAfter ["linkGeneration"] ''
        [ -e "${HOME_THEMES}/${themes.gtkTheme.name}" ] || ln -s "${themes.gtkTheme.package}/share/themes/." "${HOME_THEMES}/"
      '';
    };
    pointerCursor =
      themes.cursorTheme
      // {
        gtk.enable = true;
        x11.enable = true;
      };
    sessionVariables = {
      GTK_THEME = themes.gtkTheme.name;
      GTK_CURSOR = themes.cursorTheme.name;
      XCURSOR_THEME = themes.cursorTheme.name;
      GTK_ICON = themes.iconTheme.name;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      cursor-theme = themes.cursorTheme.name;
      gtk-theme = themes.gtkTheme.name;
      icon-theme = themes.iconTheme.name;
      # font-name = FONT;
    };
  };
}
