{
  libx,
  config,
  ...
}: let
  inherit (libx) colors;
in {
  services = {
    mako = {
      enable = true;
      actions = true;
      anchor = "top-right";
      defaultTimeout = 4500;
      ignoreTimeout = true;
      borderSize = 1;
      borderRadius = 2;
      font = config.gtk.font.name;
      icons = true;
      layer = "overlay";
      maxVisible = 3;
      padding = "10";
      width = 300;
      # iconPath = "${config.gtk.iconTheme.package}/share/icons/${config.gtk.iconTheme.name}";
      backgroundColor = "#${colors.extra.midnight}";
      borderColor = "#${colors.bold}";
      progressColor = "over #${colors.highlight.background}";
      textColor = "#${colors.highlight.foreground}";
    };
  };
}
