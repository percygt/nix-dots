{ config, pkgs, ... }:
let
  t = config.modules.themes;
in
{
  # qt = {
  #   enable = true;
  #   platformTheme = "qt5ct";
  #   style = t.qtTheme.name;
  # };

  environment.systemPackages = with pkgs; [
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    kdePackages.qt6ct
    # qt5.qtquickcontrols2
    # qt5.qtquickcontrols
    # qt5.qtbase
    # qt5.qtsvg
    # qt5.qtmultimedia
    # qt5.qtgraphicaleffects
    # qt6.qtbase
    # qt6.qtdeclarative
    # qt6.qtwayland
    # qt6.qtsvg
    # qt6.qtimageformats
    # qt6.qtmultimedia
    # qt6.qt5compat
  ];
}
