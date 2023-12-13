{lib, ...}:
with lib.hm.gvariant; {
  dconf.settings = {
    "org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9" = {
      audible-bell = true;
      background-color = "rgb(9,1,14)";
      background-transparency-percent = 20;
      bold-color = "rgb(0,255,39)";
      bold-color-same-as-fg = false;
      bold-is-bright = true;
      cursor-background-color = "rgb(48,65,194)";
      cursor-colors-set = true;
      custom-command = "fish -i";
      default-size-columns = 200;
      default-size-rows = 50;
      font = "JetBrainsMono Nerd Font 10";
      foreground-color = "rgb(150,199,241)";
      highlight-background-color = "rgb(16,115,224)";
      highlight-colors-set = true;
      login-shell = true;
      palette = ["rgb(0,0,0)" "rgb(170,0,0)" "rgb(14,186,14)" "rgb(161,212,8)" "rgb(34,34,205)" "rgb(170,0,170)" "rgb(0,170,170)" "rgb(170,170,170)" "rgb(85,85,85)" "rgb(255,85,85)" "rgb(85,255,85)" "rgb(240,238,81)" "rgb(85,85,255)" "rgb(255,85,255)" "rgb(85,255,255)" "rgb(255,255,255)"];
      scrollbar-policy = "never";
      use-custom-command = false;
      use-system-font = false;
      use-theme-colors = false;
      use-transparent-background = true;
      visible-name = "Host";
    };
  };
}
