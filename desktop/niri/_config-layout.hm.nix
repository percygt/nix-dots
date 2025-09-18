{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.niri;
  g = config._global;
  a = config.modules.themes.assets;
  f = config.modules.fonts.app;
  c = config.modules.themes.colors.withHashtag;
in
{
  programs.niri.settings.layout = {
    focus-ring.enable = false;
    border = {
      enable = true;
      width = 2;
      active.color = "#ED61D730";
      inactive.color = "#B8149F30";
    };
    shadow = {
      enable = true;
    };
    preset-window-heights = [
      { proportion = 0.5; }
      { proportion = 1.0; }
    ];
    preset-column-widths = [
      { proportion = 0.4; }
      { proportion = 0.8; }
      { proportion = 1.0; }
    ];
    default-column-width = {
      proportion = 0.8;
    };

    gaps = 6;
    struts = {
      left = 0;
      right = 0;
      top = 0;
      bottom = 0;
    };

    tab-indicator = {
      hide-when-single-tab = true;
      place-within-column = true;
      position = "left";
      corner-radius = 20.0;
      gap = -12.0;
      gaps-between-tabs = 10.0;
      width = 4.0;
      length.total-proportion = 0.1;
    };
  };
}
