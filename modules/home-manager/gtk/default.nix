{
  username,
  config,
  lib,
  pkgs,
  flakeDirectory,
  ...
}: let
  HM_GTK = "${flakeDirectory}/common/gtk";
  HOME_THEMES = "${config.home.homeDirectory}/.themes";
  LOCAL_THEMES = "${config.xdg.dataHome}/themes";
  LOCAL_ICONS = "${config.xdg.dataHome}/icons";
  GTK_THEME = "Colloid-Dark-Nord";
  BOOKMARKS = pkgs.writeText "bookmarks" ''
    file:///home/${username}/.config/home-manager
    file:///home/${username}/.local
    file:///home/${username}/.config
    file:///windows
    file:///backup
    file:///data/playground
    file:///data/git-repo
    file:///data/logs
    file:///data/codebox
    file:///data/distrobox
    file:///data
    file:///home/${username}/Documents
    file:///home/${username}/Music
    file:///home/${username}/Pictures
    file:///home/${username}/Videos
    file:///home/${username}/Downloads
  '';
in {
  xdg.configFile = {
    "gtk-3.0/gtk.css" = {
      text = ''
        VteTerminal,
        TerminalScreen,
        vte-terminal {
          padding: 5px;
        }
      '';
    };
    "gtk-4.0/assets" = {
      source = ../../../config/gtk/themes/${GTK_THEME}/gtk-4.0/assets;
    };
    "gtk-4.0/gtk.css " = {
      source = ../../../config/gtk/themes/${GTK_THEME}/gtk-4.0/gtk.css;
    };
    "gtk-4.0/gtk-dark.css " = {
      source = ../../../config/gtk/themes/${GTK_THEME}/gtk-4.0/gtk-dark.css;
    };
  };

  home = {
    activation = {
      linkGtkIfDoesNotExist = lib.hm.dag.entryAfter ["linkGeneration"] ''
        [ -e "${HOME_THEMES}" ] || mkdir "${HOME_THEMES}"
        [ -e "${LOCAL_THEMES}" ] || mkdir "${LOCAL_THEMES}"
        [ -e "${LOCAL_ICONS}" ] || mkdir "${LOCAL_ICONS}"
        [ -e "${config.xdg.configHome}/gtk-3.0/" ] || mkdir "${config.xdg.configHome}/gtk-3.0/"

        [ -f "${config.xdg.configHome}/gtk-3.0/bookmarks" ] || cp "${BOOKMARKS}" "${config.xdg.configHome}/gtk-3.0/bookmarks"
        [ -e "${LOCAL_THEMES}/Colloid-Dark-Nord" ] || ln -s "${HM_GTK}/themes/Colloid-Dark-Nord" "${LOCAL_THEMES}/Colloid-Dark-Nord"
        [ -e "${HOME_THEMES}/Colloid-Dark-Nord" ] || cp -r "${HM_GTK}/themes/Colloid-Dark-Nord" "${HOME_THEMES}/Colloid-Dark-Nord"

        [ -e "${LOCAL_THEMES}/Marble-crispblue-dark" ] || ln -s "${HM_GTK}/themes/Marble-crispblue-dark" "${LOCAL_THEMES}/Marble-crispblue-dark"
        [ -e "${HOME_THEMES}/Marble-crispblue-dark" ] || cp -r "${HM_GTK}/themes/Marble-crispblue-dark" "${HOME_THEMES}/Marble-crispblue-dark"

        [ -e "${LOCAL_ICONS}/hicolor" ] || cp -r "${HM_GTK}/icons/hicolor" "${LOCAL_ICONS}/hicolor"
        [ -e "${LOCAL_ICONS}/Papirus" ] || cp -r "${HM_GTK}/icons/Papirus" "${LOCAL_ICONS}/Papirus"
        [ -e "${LOCAL_ICONS}/Win11" ] || cp -r "${HM_GTK}/icons/Win11" "${LOCAL_ICONS}/Win11"
        [ -e "${LOCAL_ICONS}/Colloid-dark-cursors" ] || cp -r "${HM_GTK}/icons/Colloid-dark-cursors" "${LOCAL_ICONS}/Colloid-dark-cursors"
      '';
      # removeSomething = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
      # '';
    };
  };
}
