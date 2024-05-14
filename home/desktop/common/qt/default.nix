{
  lib,
  config,
  ...
}: {
  options = {
    desktop.modules.qt.enable =
      lib.mkEnableOption "Enables qt";
  };
  config = lib.mkIf config.desktop.modules.qt.enable {
    qt = {
      enable = true;
      platformTheme = "gtk";
      # platformTheme.name = "gtk";
      style.name = "kvantum";
    };

    home.sessionVariables = {
      QT_STYLE_OVERRIDE = "kvantum";
    };

    xdg.configFile = {
      "Kvantum" = {
        recursive = false;
        source = ./config/qt/Kvantum;
      };
      kdeglobals.source = ./config/qt/kdeglobals;
    };
  };
}
