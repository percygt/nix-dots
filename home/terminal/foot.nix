{ui, ...}: let
  inherit (ui) colors;
in {
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        login-shell = "yes";
        font = "VictorMono Nerd Font:style=SemiBold:size=12";
        letter-spacing = 0.25;
        box-drawings-uses-font-glyphs = "yes";
      };

      cursor = {
        blink = "yes";
      };

      mouse = {
        hide-when-typing = "yes";
      };

      csd = {
        preferred = "server";
        color = "ff000000";
        size = 1;
        hide-when-maximized = "yes";
      };

      colors = {
        inherit (colors) alpha;
        inherit (colors.default) background foreground;

        ## Normal/regular colors (color palette 0-7)
        regular0 = colors.normal.black; # black
        regular1 = colors.normal.red; # red
        regular2 = colors.normal.green; # green
        regular3 = colors.normal.yellow; # yellow
        regular4 = colors.normal.blue; # blue
        regular5 = colors.normal.magenta; # magenta
        regular6 = colors.normal.cyan; # cyan
        regular7 = colors.normal.white; # white

        ## Bright colors (color palette 8-15)
        bright0 = colors.bright.black; # bright black
        bright1 = colors.bright.red; # bright red
        bright2 = colors.bright.green; # bright green
        bright3 = colors.bright.yellow; # bright yellow
        bright4 = colors.bright.blue; # bright blue
        bright5 = colors.bright.magenta; # bright magenta
        bright6 = colors.bright.cyan; # bright cyan
        bright7 = colors.bright.white; # bright white
      };
    };
  };
}
