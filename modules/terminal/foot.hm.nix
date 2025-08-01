{
  lib,
  config,
  ...
}:
let
  f = config.modules.fonts.shell;
  t = config.modules.themes;
  c = t.colors;
  g = config._base;
  cfg = config.modules.terminal.foot;
in
{
  config = lib.mkIf cfg.enable {
    programs.foot = {
      enable = true;
      inherit (cfg) package;
      settings = {
        main = {
          term = "foot";
          login-shell = "no";
          shell = lib.getExe g.shell.defaultPackage;
          font = "${f.name}:style=${builtins.elemAt f.style 0}:size=${builtins.toString f.size}";
          font-bold = "${f.name}:style=${builtins.elemAt f.style 1}:size=${builtins.toString (f.size + 0.5)}";
          font-italic = "${f.name}:style=${builtins.elemAt f.style 2}:size=${builtins.toString f.size}";
          font-bold-italic = "${f.name}:style=${builtins.elemAt f.style 3}:size=${
            builtins.toString (f.size + 0.5)
          }";
          underline-offset = 1.2;
          underline-thickness = 1;
          resize-by-cells = "no";
          line-height = 20;
          pad = "10x6";
        };

        cursor = {
          blink = "yes";
          style = "beam";
          color = "${c.base01} ${c.base05}";
        };

        mouse.hide-when-typing = "yes";

        csd = {
          preferred = "server";
          color = "ff000000";
          size = 1;
          border-width = 1;
          hide-when-maximized = "yes";
        };

        colors = {
          alpha = t.opacity;
          background = c.base00;
          foreground = c.base05;

          ## Normal/regular colors (color palette 0-7)
          regular0 = c.base01; # black
          regular1 = c.base08; # red
          regular2 = c.base0B; # green
          regular3 = c.base09; # yellow
          regular4 = c.base0D; # blue
          regular5 = c.base0E; # magenta
          regular6 = c.base0C; # cyan
          regular7 = c.base06; # white

          ## Bright colors (color palette 8-15)
          bright0 = c.base02; # bright black
          bright1 = c.base12; # bright red
          bright2 = c.base14; # bright green
          bright3 = c.base13; # bright yellow
          bright4 = c.base16; # bright blue
          bright5 = c.base17; # bright magenta
          bright6 = c.base15; # bright cyan
          bright7 = c.base07; # bright white

          "16" = c.base09;
          "17" = c.base0F;
          "18" = c.base01;
          "19" = c.base02;
          "20" = c.base04;
          "21" = c.base06;
          ## Misc colors
          selection-background = c.base02;
          urls = c.base04;
        };
      };
    };
  };
}
