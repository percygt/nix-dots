{
  qt = {
    enable = true;
    style.name = "kvantum";
  };
  xdg.configFile = {
    "Kvantum" = {
      recursive = false;
      source = ../_config/qt/Kvantum;
    };
    kdeglobals.source = ../_config/qt/kdeglobals;
  };
}
