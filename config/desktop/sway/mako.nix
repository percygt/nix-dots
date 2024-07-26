{ config, ... }:
let
  t = config.modules.theme.iconTheme;
  f = config.modules.fonts.interface;
  c = config.modules.theme.colors.withHashtag;
in
{
  services = {
    mako = {
      enable = true;
      actions = true;
      anchor = "top-right";
      defaultTimeout = 5000;
      ignoreTimeout = true;
      borderSize = 1;
      borderRadius = 5;
      font = "${f.name} ${toString f.size}";
      icons = true;
      layer = "overlay";
      maxVisible = 3;
      padding = "15";
      width = 400;
      iconPath = "${config.xdg.dataHome}/icons/${t.name}";
      backgroundColor = c.base01;
      borderColor = c.base03;
      progressColor = "over ${c.base04}";
      textColor = c.base05;
    };
  };
}
