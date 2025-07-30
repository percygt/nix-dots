{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.sway;
  g = config._base;
  a = config.modules.themes.assets;
  f = config.modules.fonts.app;
  c = config.modules.themes.colors.withHashtag;

in
{
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  xdg.configFile = {
    "niri/config.kdl".source =
      config.lib.file.mkOutOfStoreSymlink "${g.flakeDirectory}/desktop/niri/config.kdl";
  };
}
