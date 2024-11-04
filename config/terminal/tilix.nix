{ config, pkgs, ... }:
let
  g = config._base;
  t = config.modules.theme;
  c = t.colors.withHashtag;
  f = config.modules.fonts.shell;
in
{
  home.packages = [ g.terminal.tilix.package ];
  dconf.settings = {
    "com/gexperts/Tilix" = {
      enable-wide-handle = true;
      tab-position = "bottom";
      terminal-title-style = "normal";
      theme-variant = "dark";
      use-overlay-scrollbar = true;
      window-style = "borderless";
    };
    "com/gexperts/Tilix/profiles/2b7c4080-0ddd-46c5-8f23-563fd3ba789d" = {
      bold-color-set = false;
      dim-transparency-percent = 0;
      badge-color-set = false;
      background-transparency-percent = builtins.floor ((1 - t.opacity) * 100);
      foreground-color = c.base05;
      background-color = c.base00;
      cursor-background-color = c.base07;
      bold-color = c.base09;
      highlight-background-color = c.base02;
      palette = [
        c.base01 # black
        c.base08 # red
        c.base0B # green
        c.base09 # yellow
        c.base0D # blue
        c.base0E # magenta
        c.base0C # cyan
        c.base06 # white
        c.base02 # bright black
        c.base12 # bright red
        c.base14 # bright green
        c.base13 # bright yellow
        c.base16 # bright blue
        c.base17 # bright magenta
        c.base15 # bright cyan
        c.base07 # bright white
      ];
      audible-bell = true;
      bold-color-same-as-fg = false;
      bold-is-bright = true;
      cursor-colors-set = true;
      default-size-columns = 200;
      default-size-rows = 50;
      font = "${f.name} ${builtins.toString f.size}";
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
