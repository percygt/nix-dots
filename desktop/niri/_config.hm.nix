{
  config,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.modules.desktop.sway;
  g = config._base;
  a = config.modules.themes.assets;
  f = config.modules.fonts.app;
  c = config.modules.themes.colors.withHashtag;
  pointer = config.home.pointerCursor;
  makeCommand = command: {
    command = [ command ];
  };
in
{

  # xdg.configFile = {
  #   "niri/config.kdl".source =
  #     config.lib.file.mkOutOfStoreSymlink "${g.flakeDirectory}/desktop/niri/config.kdl";
  # };
}
