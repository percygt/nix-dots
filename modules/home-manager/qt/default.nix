{
  qt = {
    enable = true;
    style.name = "kvantum";
  };
  xdg.configFile = {
    "Kvantum" = {
      recursive = false;
      source = ../../../config/qt/Kvantum;
    };
    kdeglobals.source = ../../../config/qt/kdeglobals;
  };
}
