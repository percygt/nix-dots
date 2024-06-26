{
  libx,
  config,
  ...
}: let
  inherit (libx) colors fonts iconTheme;
in {
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
      backgroundColor = "#${colors.extra.obsidian}";
      borderColor = "#${colors.extra.azure}";
      progressColor = "over #${colors.highlight.background}";
      textColor = "#${colors.default.foreground}";
    };
  };
}
