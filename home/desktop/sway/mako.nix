{libx, ...}: let
  inherit (libx) colors fonts;
in {
  services = {
    mako = {
      enable = true;
      actions = true;
      anchor = "top-right";
      defaultTimeout = 5000;
      ignoreTimeout = true;
      borderSize = 2;
      borderRadius = 5;
      font = fonts.interface.name;
      icons = true;
      layer = "overlay";
      maxVisible = 3;
      padding = "15";
      width = 400;
      # iconPath = "${config.gtk.iconTheme.package}/share/icons/${config.gtk.iconTheme.name}";
      backgroundColor = "#${colors.normal.black}";
      borderColor = "#${colors.normal.blue}";
      progressColor = "over #${colors.highlight.background}";
      textColor = "#${colors.default.foreground}";
    };
  };
}
