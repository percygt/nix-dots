{
  qt = {
    enable = true;
    style.name = "kvantum";
  };
  xdg.configFile = {
    "Kvantum" = {
      recursive = false;
      source = ../../common/qt/Kvantum;
    };
    kdeglobals.source = ../../common/qt/kdeglobals;
  };
}
