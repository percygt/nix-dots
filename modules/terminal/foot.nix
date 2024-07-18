{
  configx,
  lib,
  config,
  ...
}:
let
  inherit (configx) background fonts;
  b = config.scheme;
in
{
  options.terminal.foot.home.enable = lib.mkEnableOption "Enable foot";

  config = lib.mkIf config.terminal.foot.home.enable {
    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          term = "xterm-256color";
          login-shell = "yes";
          font = "${fonts.shell.name}:style=${fonts.shell.style}:size=${builtins.toString fonts.shell.size}";
          line-height = 23;
          pad = "10x8";
        };

        cursor = {
          blink = "yes";
          style = "beam";
        };

        mouse.hide-when-typing = "yes";

        csd = {
          preferred = "server";
          color = "ff000000";
          size = 1;
          hide-when-maximized = "yes";
        };

        colors = {
          alpha = background.opacity;
          background = b.base00;
          foreground = b.base05;

          ## Normal/regular colors (color palette 0-7)
          regular0 = b.base01; # black
          regular1 = b.base08; # red
          regular2 = b.base0B; # green
          regular3 = b.base09; # yellow
          regular4 = b.base0D; # blue
          regular5 = b.base0E; # magenta
          regular6 = b.base0C; # cyan
          regular7 = b.base06; # white

          ## Bright colors (color palette 8-15)
          bright0 = b.base02; # bright black
          bright1 = b.base12; # bright red
          bright2 = b.base14; # bright green
          bright3 = b.base13; # bright yellow
          bright4 = b.base16; # bright blue
          bright5 = b.base17; # bright magenta
          bright6 = b.base15; # bright cyan
          bright7 = b.base07; # bright white

          "16" = b.base09;
          "17" = b.base0F;
          "18" = b.base01;
          "19" = b.base02;
          "20" = b.base04;
          "21" = b.base06;
          ## Misc colors
          selection-background = b.base02;
          urls = b.base04;
        };
      };
    };
  };
}
