{colors, ...}: {
  dconf.settings = {
    "org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9" = {
      foreground-color = "#${colors.default.foreground}";
      background-color = "#${colors.default.background}";
      cursor-background-color = "#${colors.cursor.background}";
      bold-color = "#${colors.bold}";
      highlight-background-color = "#${colors.highlight.background}";
      palette = [
        "#${colors.normal.black}"
        "#${colors.normal.red}"
        "#${colors.normal.green}"
        "#${colors.normal.yellow}"
        "#${colors.normal.blue}"
        "#${colors.normal.magenta}"
        "#${colors.normal.cyan}"
        "#${colors.normal.white}"
        "#${colors.bright.black}"
        "#${colors.bright.red}"
        "#${colors.bright.green}"
        "#${colors.bright.yellow}"
        "#${colors.bright.blue}"
        "#${colors.bright.magenta}"
        "#${colors.bright.cyan}"
        "#${colors.bright.white}"
      ];
      audible-bell = true;
      background-transparency-percent = 0.95 * 100;
      bold-color-same-as-fg = false;
      bold-is-bright = true;
      cursor-colors-set = true;
      custom-command = "fish -i";
      default-size-columns = 200;
      default-size-rows = 50;
      font = "JetBrainsMono Nerd Font 10";
      highlight-colors-set = true;
      login-shell = true;
      scrollbar-policy = "never";
      use-custom-command = false;
      use-system-font = false;
      use-theme-colors = false;
      use-transparent-background = true;
      visible-name = "Host";
    };
  };
}
