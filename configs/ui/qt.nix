{ config, ... }:
let
  cfg = config.modules.themes.qtTheme;
in
{
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = cfg.name;
  };

  home.sessionVariables = {
    QT_STYLE_OVERRIDE = cfg.name;
  };

  xdg.configFile = {
    "Kvantum" = {
      recursive = false;
      source = "${cfg.package}/share/Kvantum";
    };
    kdeglobals.source = "${cfg.package}/share/kdeglobals";
  };
}
