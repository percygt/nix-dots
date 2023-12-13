{
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        login-shell = "yes";
        font = "JetBrainsMono Nerd Font:size=10.5";
        font-size-adjustment = 1;
        letter-spacing = 0;
        vertical-letter-offset = 0.5;
        box-drawings-uses-font-glyphs = "yes";
        pad = "10x10";
      };

      cursor = {
        blink = "yes";
      };

      mouse = {
        hide-when-typing = "yes";
      };

      csd = {
        preferred = "none";
      };

      colors = {
        alpha = 0.9;
        background = "09010E";
        foreground = "96C7F1";

        ## Normal/regular colors (color palette 0-7)
        regular0 = "000000"; # black
        regular1 = "AA0000"; # red
        regular2 = "0EBA0E"; # green
        regular3 = "A1D408"; # yellow
        regular4 = "2222CD"; # blue
        regular5 = "AA00AA"; # magenta
        regular6 = "00AAAA"; # cyan
        regular7 = "AAAAAA"; # white

        ## Bright colors (color palette 8-15)
        bright0 = "555555"; # bright black
        bright1 = "FF5555"; # bright red
        bright2 = "55FF55"; # bright green
        bright3 = "F0EE51"; # bright yellow
        bright4 = "5555FF"; # bright blue
        bright5 = "FF55FF"; # bright magenta
        bright6 = "55FFFF"; # bright cyan
        bright7 = "FFFFFF"; # bright white
      };
    };
  };
}
