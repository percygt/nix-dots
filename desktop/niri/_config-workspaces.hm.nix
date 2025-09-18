{
  config,
  pkgs,
  inputs,
  homeDirectory,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.niri;
  g = config._global;
  a = config.modules.themes.assets;
  f = config.modules.fonts.app;
  c = config.modules.themes.colors.withHashtag;
  inherit (config.modules.themes)
    cursorTheme
    iconTheme
    gtkTheme
    ;
in
{
  programs.niri.settings.workspaces = {
    #   main = {
    #     open-on-output = "HDMI-A-1";
    #   };
    #   scratchpad = {
    #
    #     open-on-output = "HDMI-A-1";
    #   };
    # };
  };
}
