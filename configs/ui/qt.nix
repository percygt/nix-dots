{ config, ... }:
let
  cfg = config.modules.themes.qtTheme;
in
{
  qt = {
    enable = true;
    platformTheme.name = "qt5ct";
    style.name = cfg.name;
  };

  xdg.configFile = {
    "Kvantum" = {
      recursive = false;
      source = "${cfg.package}/share/Kvantum";
    };
    kdeglobals.source = "${cfg.package}/share/kdeglobals";
  };
}
