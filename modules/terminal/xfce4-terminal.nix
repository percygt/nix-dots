{
  config,
  lib,
  desktop,
  ...
}:
let
  t = config.modules.themes;
  c = t.colors.withHashtag;
  f = config.modules.fonts.shell;
  g = config._base;
  color-palette = builtins.concatStringsSep ";" [
    c.base01
    c.base08
    c.base0B
    c.base09
    c.base0D
    c.base0E
    c.base0C
    c.base06
    c.base02
    c.base12
    c.base14
    c.base13
    c.base16
    c.base17
    c.base15
    c.base07
  ];
in
{
  config = lib.mkIf config.modules.terminal.xfce4-terminal.enable (
    lib.mkMerge [
      (lib.mkIf (desktop == "sway") {
        wayland.windowManager.sway.config.keybindings = {
          "Alt+shift+return" = "exec ${lib.getExe g.terminal.xfce4-terminal.package}";
        };
      })
      {
        home.packages = [ g.terminal.xfce4-terminal.package ];
        xfconf.settings = {
          xfce4-terminal = {
            inherit color-palette;
            background-mode = "TERMINAL_BACKGROUND_TRANSPARENT";
            font-name = "${f.name} SemiBold ${builtins.toString f.size}";
            font-use-system = false;
            font-allow-bold = true;
            text-blink-mode = "TERMINAL_TEXT_BLINK_MODE_ALWAYS";
            color-cursor = "${c.base05}";
            color-foreground = "${c.base05}";
            background-darkness = 1 - t.opacity;
            misc-menubar-default = false;
            misc-borders-default = false;
            misc-toolbar-default = false;
            misc-slim-tabs = true;
            cell-width-scale = 1;
            color-cursor-use-default = false;
            misc-confirm-close = false;
            color-selection-use-default = false;
            color-bold-use-default = false;
            color-use-theme = false;
            run-custom-command = false;
            color-background-vary = false;
            misc-cursor-shape = "TERMINAL_CURSOR_SHAPE_BLOCK";
            misc-cursor-blinks = true;
            misc-copy-on-select = true;
            overlay-scrolling = true;
            color-cursor-foreground = "${c.base05}";
            color-selection = "${c.base02}";
            color-selection-background = "${c.base08}";
            color-bold = "${c.base09}";
            color-bold-is-bright = true;
            dropdown-show-borders = false;
            misc-bell = false;
            cell-height-scale = 1.2;
            misc-bell-urgent = false;
            misc-hyperlinks-enabled = true;
            misc-right-click-action = "TERMINAL_RIGHT_CLICK_ACTION_CONTEXT_MENU";
            misc-show-unsafe-paste-dialog = false;
            scrolling-unlimited = true;
            title-mode = "TERMINAL_TITLE_REPLACE";
          };
        };
      }
    ]
  );
}
