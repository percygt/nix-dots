let
  colors = (import ../../colors.nix).syft;
in {
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      window.opacity = colors.alpha;
      colors = {
        primary = {
          foreground = "#${colors.default.foreground}";
          background = "#${colors.default.background}";
        };
        cursor = {
          text = "#${colors.cursor.foreground}";
          cursor = "#${colors.cursor.background}";
        };
        normal = {
          black = "#${colors.normal.black}";
          red = "#${colors.normal.red}";
          green = "#${colors.normal.green}";
          yellow = "#${colors.normal.yellow}";
          blue = "#${colors.normal.blue}";
          magenta = "#${colors.normal.magenta}";
          cyan = "#${colors.normal.cyan}";
          white = "#${colors.normal.white}";
        };
        bright = {
          black = "#${colors.bright.black}";
          red = "#${colors.bright.red}";
          green = "#${colors.bright.green}";
          yellow = "#${colors.bright.yellow}";
          blue = "#${colors.bright.blue}";
          magenta = "#${colors.bright.magenta}";
          cyan = "#${colors.bright.cyan}";
          white = "#${colors.bright.white}";
        };
      };
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold Italic";
        };
        size = 11;
      };
    };
  };
}
