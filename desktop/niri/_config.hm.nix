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
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };
  # xdg.configFile = {
  #   "niri/config.kdl".source =
  #     config.lib.file.mkOutOfStoreSymlink "${g.flakeDirectory}/desktop/niri/config.kdl";
  # };
}
