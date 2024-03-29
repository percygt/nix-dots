{
  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "kvantum";
  };

  home.sessionVariables = {
    QT_QPA_PLATFORM = "xcb;wayland";
    QT_STYLE_OVERRIDE = "kvantum";
  };

  xdg.configFile = {
    "Kvantum" = {
      recursive = false;
      source = ./config/qt/Kvantum;
    };
    kdeglobals.source = ./config/qt/kdeglobals;
  };
}
