{ config, ... }:
let
  t = config.modules.themes;
  f = config.modules.fonts.app;
  fsize = builtins.toString f.size;
in
{
  xdg.configFile = {
    "Kvantum" = {
      recursive = false;
      source = "${t.qtTheme.package}/share/Kvantum";
    };
    kdeglobals.source = "${t.qtTheme.package}/share/kdeglobals";
    "qt6ct/qt6ct.conf".text = ''
      [Appearance]
      icon_theme=${t.iconTheme.name}
      style=${t.qtTheme.name}

      [Fonts]
      fixed="${f.name},${fsize},-1,5,700,0,0,0,0,0,0,0,0,0,0,1,Regular"
      general="${f.name},${fsize},-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Bold"
    '';
    "qt5ct/qt5ct.conf".text = ''
      [Appearance]
      icon_theme=${t.iconTheme.name}
      style=${t.qtTheme.name}

      [Fonts]
      fixed="${f.name},${fsize},-1,5,700,0,0,0,0,0,0,0,0,0,0,1,Regular"
      general="${f.name},${fsize},-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Bold"
    '';
  };
}
