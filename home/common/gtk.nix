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
  # Now symlink the `~/.config/gtk-4.0/` folder declaratively:
  xdg.configFile = {
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  };
  home.file = {
    gtk-theme-dataHome = {
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}";
      target = "${config.xdg.dataHome}/themes/${config.gtk.theme.name}";
    };
    gtk-theme-home = {
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}";
      target = "${config.home.homeDirectory}/.themes/${config.gtk.theme.name}";
    };
    # wayland-cursor-fix = {
    #   recursive = false;
    #   text = ''
    #     [Icon Theme]
    #     Inherits=${config.gtk.cursorTheme.name}
    #   '';
    #   target = "${config.xdg.dataHome}/icons/default/index.theme";
    # };
  };

  home = {
    packages = with pkgs; [
      ffmpegthumbnailer
    ];
    # activation = {
    #   cpGtkThemeIfDoesNotExist = lib.hm.dag.entryAfter ["linkGeneration"] ''
    #     [ ! -e "${HOME_THEMES}" ] || mkdir -p "${HOME_THEMES}"
    #   '';
    # };
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
      XCURSOR_SIZE = builtins.toString themes.cursorTheme.size;
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
