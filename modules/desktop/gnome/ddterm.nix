{ configx, ... }:
let
  inherit (configx) colors;
in
{
  dconf.settings = {
    "com/github/amezin/ddterm" = {
      background-opacity = colors.alpha;
      foreground-color = "#${colors.default.foreground}";
      background-color = "#${colors.default.background}";
      cursor-foreground-color = "#${colors.cursor.foreground}";
      cursor-background-color = "#${colors.cursor.background}";
      bold-color = "#${colors.bold}";
      highlight-foreground-color = "#${colors.highlight.foreground}";
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
      allow-hyperlink = true;
      bold-color-same-as-fg = false;
      bold-is-bright = true;
      cjk-utf8-ambiguous-width = "narrow";
      command = "user-shell-login";
      cursor-blink-mode = "on";
      cursor-colors-set = true;
      cursor-shape = "ibeam";
      custom-command = "fish -i";
      custom-font = "JetBrainsMono Nerd Font 11";
      ddterm-activate-hotkey = [ ];
      ddterm-toggle-hotkey = [ "<Super>d" ];
      detect-urls = true;
      force-x11-gdk-backend = false;
      hide-animation = "ease-in-quart";
      hide-animation-duration = 0.2;
      hide-when-focus-lost = false;
      hide-window-on-esc = false;
      highlight-colors-set = true;
      new-tab-button = true;
      new-tab-front-button = false;
      notebook-border = false;
      override-window-animation = true;
      panel-icon-type = "none";
      pointer-autohide = true;
      preserve-working-directory = true;
      scroll-on-output = true;
      shortcut-background-opacity-dec = [ ];
      shortcut-background-opacity-inc = [ ];
      shortcut-find-prev = [ ];
      shortcut-move-tab-next = [ ];
      shortcut-move-tab-prev = [ ];
      shortcut-move-tab-to-other-pane = [ ];
      shortcut-next-tab = [ ];
      shortcut-page-close = [ "<Primary><Shift>w" ];
      shortcut-prev-tab = [ ];
      shortcut-split-horizontal = [ "<Primary><Shift>Down" ];
      shortcut-split-vertical = [ "<Primary><Shift>Right" ];
      shortcut-switch-to-tab-1 = [ ];
      shortcut-switch-to-tab-10 = [ ];
      shortcut-switch-to-tab-2 = [ ];
      shortcut-switch-to-tab-3 = [ ];
      shortcut-switch-to-tab-4 = [ ];
      shortcut-switch-to-tab-5 = [ ];
      shortcut-switch-to-tab-6 = [ ];
      shortcut-switch-to-tab-7 = [ ];
      shortcut-switch-to-tab-8 = [ ];
      shortcut-switch-to-tab-9 = [ ];
      shortcut-terminal-copy-html = [ "<Primary><Shift>h" ];
      shortcut-terminal-paste = [ "<Primary><Shift>v" ];
      shortcut-terminal-select-all = [ "<Primary><Shift>a" ];
      shortcut-toggle-maximize = [ ];
      shortcut-win-new-tab = [ "<Primary><Shift>t" ];
      shortcut-window-size-dec = [ ];
      shortcut-window-size-inc = [ ];
      shortcuts-enabled = true;
      show-animation = "ease-in-out-sine";
      show-animation-duration = 5.0e-2;
      show-scrollbar = false;
      tab-close-buttons = false;
      tab-expand = true;
      tab-label-ellipsize-mode = "end";
      tab-label-width = 0.1;
      tab-policy = "automatic";
      tab-position = "bottom";
      tab-show-shortcuts = false;
      tab-switcher-popup = true;
      text-blink-mode = "focused";
      theme-variant = "dark";
      transparent-background = true;
      use-system-font = false;
      use-theme-colors = false;
      window-above = true;
      window-maximize = false;
      window-monitor = "current";
      window-monitor-connector = "eDP-1";
      window-position = "top";
      window-resizable = true;
      window-size = 0.5;
      window-skip-taskbar = true;
      window-stick = true;
      window-type-hint = "normal";
    };
  };
}
