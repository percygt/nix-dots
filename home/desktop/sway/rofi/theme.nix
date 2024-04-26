{
  config,
  colors,
  fonts,
  ...
}: {
  theme = let
    inherit (config.lib.formats.rasi) mkLiteral;
  in {
    "*" = {
      bg-col = mkLiteral "#${colors.default.background}";
      bg-col-light = mkLiteral "#${colors.normal.blue}";
      border-col = mkLiteral "#${colors.normal.black}";
      selected-col = mkLiteral "#${colors.bold}";
      accent = mkLiteral "#${colors.extra.obsidian}";
      fg-col = mkLiteral "#${colors.default.foreground}";
      grey = mkLiteral "#${colors.extra.overlay0}";

      width = 500;
      font = "${fonts.interface.name} 18";
      text-color = mkLiteral "@fg-col";
    };

    "element-text,element-icon,mode-switcher" = {
      background-color = mkLiteral "inherit";
    };

    "window" = {
      height = 600;
      border = 2;
      border-color = mkLiteral "@border-col";
      background-color = mkLiteral "@bg-col";
      border-radius = 5;
    };

    "mainbox" = {
      background-color = mkLiteral "@bg-col";
      border-radius = 5;
      padding = mkLiteral "10";
    };

    "inputbar" = {
      children = mkLiteral "[ entry ]";
      background-color = mkLiteral "@bg-col";
      border-radius = 5;
      padding = mkLiteral "10";
    };

    "prompt" = {
      padding = 10;
      border-radius = 5;
    };

    "entry" = {
      padding = 10;
      background-color = mkLiteral "@accent";
    };

    "listview" = {
      lines = 10;
      background-color = mkLiteral "@bg-col";
    };

    "element" = {
      padding = 5;
      background-color = mkLiteral "@bg-col";
    };

    "element-icon" = {
      size = 35;
    };

    "element selected" = {
      text-color = mkLiteral "@selected-col";
      background-color = mkLiteral "@bg-col";
    };
  };
}
