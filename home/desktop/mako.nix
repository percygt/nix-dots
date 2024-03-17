{
  config,
  colors,
  ...
}: {
  services = {
    mako = {
      enable = true;
      actions = true;
      anchor = "top-right";
      borderRadius = 8;
      borderSize = 1;
      defaultTimeout = 10000;
      font = config.gtk.font.name;
      iconPath = "${config.gtk.iconTheme.package}/share/icons/${config.gtk.iconTheme.name}";
      icons = true;
      layer = "overlay";
      maxVisible = 3;
      padding = "10";
      width = 300;

      backgroundColor = "${colors.default.background}";
      borderColor = "${colors.highlight.background}";
      progressColor = "over ${colors.default.foreground}";
      textColor = "${colors.highlight.foreground}";

      extraConfig = ''
        [urgency=high]
        border-color=${colors.bold}
      '';
    };
  };
}
