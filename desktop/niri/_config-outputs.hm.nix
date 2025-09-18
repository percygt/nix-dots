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
  programs.niri.settings.outputs = {
    "eDP-1" = {
      scale = 1.0;
      position = {
        x = 0;
        y = 0;
      };
    };
    "HDMI-A-1" = {
      focus-at-startup = true;
      mode = {
        width = 1920;
        height = 1080;
        refresh = null;
      };
      scale = 1.0;
      position = {
        x = 1920;
        y = 0;
      };
    };
  };
}
