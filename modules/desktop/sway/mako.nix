{ configx, config, ... }:
let
  inherit (configx) fonts themes;
  inherit (themes) iconTheme;
  c = config.scheme.withHashtag;
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
      font = "${fonts.interface.name} ${toString fonts.interface.size}";
      icons = true;
      layer = "overlay";
      maxVisible = 3;
      padding = "15";
      width = 400;
      iconPath = "${config.xdg.dataHome}/icons/${iconTheme.name}";
      backgroundColor = c.base01;
      borderColor = c.base03;
      progressColor = "over ${c.base04}";
      textColor = c.base05;
    };
  };
}
