{
  config,
  ...
}:
let
  f = config.modules.fonts.interface;
  t = config.modules.themes;
  c = t.colors;
  font = "${f.name}:size=${str f.size}";
  str = char: builtins.toString char;
  setAlpha = col: "${col}ff";
in
{
  services.fnott = {
    enable = true;
    settings = {
      main = {
        title-format = "<i>%a%A<i>";
        summary-format = "<b>%s</b>";
        body-format = "%b";
        icon-theme = config.gtk.iconTheme.name;
        notification-margin = 4;
        padding-vertical = 10;
        padding-horizontal = 10;
        default-timeout = 5;
        border-size = 2;
        anchor = "bottom-right";

        title-font = font;
        summary-font = font;
        body-font = font;

        title-color = setAlpha c.base05;
        summary-color = setAlpha c.base05;
        body-color = setAlpha c.base05;
        progress-color = setAlpha c.base02;
        background = setAlpha c.base00;
      };

      low.border-color = setAlpha c.base0B;
      normal.border-color = setAlpha c.base0E;
      critical.border-color = setAlpha c.base08;
    };
  };
}
