{
  dconf.settings = {
    "com/github/stunkymonkey/nautilus-open-any-terminal" = {
      keybindings = "<Win>f";
      terminal = "foot";
    };

    "org/gnome/desktop/wm/keybindings" = {
      activate-window-menu = [ "<Alt>space" ];
      always-on-top = [ ];
      begin-move = [ ];
      begin-resize = [ ];
      close = [ "<Shift><Control>q" ];
      cycle-group = [ "<Alt>F6" ];
      cycle-group-backward = [ "<Shift><Alt>F6" ];
      cycle-panels = [ "<Control><Alt>Escape" ];
      cycle-panels-backward = [ "<Shift><Control><Alt>Escape" ];
      cycle-windows = [ "<Alt>Escape" ];
      cycle-windows-backward = [ "<Shift><Alt>Escape" ];
      lower = [ ];
      maximize = [ ];
      maximize-horizontally = [ ];
      maximize-vertically = [ ];
      move-to-center = [ ];
      move-to-corner-ne = [ ];
      move-to-corner-nw = [ ];
      move-to-corner-se = [ ];
      move-to-corner-sw = [ ];
      move-to-monitor-down = [ "<Shift><Control><Super>j" ];
      move-to-monitor-left = [ "<Shift><Control><Super>h" ];
      move-to-monitor-right = [ "<Shift><Control><Super>l" ];
      move-to-monitor-up = [ "<Shift><Control><Super>k" ];
      move-to-side-e = [ ];
      move-to-side-n = [ ];
      move-to-side-s = [ ];
      move-to-side-w = [ ];
      move-to-workspace-11 = [ ];
      move-to-workspace-12 = [ ];
      move-to-workspace-down = [ ];
      move-to-workspace-left = [
        "<Control><Super>h"
        "<Super><Shift>Page_Up"
      ];
      move-to-workspace-right = [
        "<Control><Super>l"
        "<Super><Shift>Page_Down"
      ];
      move-to-workspace-up = [ ];
      panel-main-menu = [ "<Alt>F1" ];
      panel-run-dialog = [ "<Alt>F2" ];
      raise = [ ];
      raise-or-lower = [ ];
      set-spew-mark = [ ];
      switch-input-source = [ ];
      switch-input-source-backward = [ ];
      switch-panels = [ "<Control><Alt>Tab" ];
      switch-panels-backward = [ "<Shift><Control><Alt>Tab" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-10 = [ ];
      switch-to-workspace-11 = [ ];
      switch-to-workspace-12 = [ ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-5 = [ "<Super>5" ];
      switch-to-workspace-6 = [ "<Super>6" ];
      switch-to-workspace-7 = [ "<Super>7" ];
      switch-to-workspace-8 = [ "<Super>8" ];
      switch-to-workspace-9 = [ "<Super>9" ];
      switch-to-workspace-down = [ ];
      switch-to-workspace-last = [ "<Super>End" ];
      switch-to-workspace-left = [
        "<Control><Alt>h"
        "<Super>Page_Up"
      ];
      switch-to-workspace-right = [
        "<Control><Alt>l"
        "<Super>Page_Down"
      ];
      switch-to-workspace-up = [ ];
      toggle-above = [ ];
      toggle-fullscreen = [ "F11" ];
      toggle-maximized = [ "<Super>m" ];
      toggle-on-all-workspaces = [ ];
      toggle-shaded = [ ];
      unmaximize = [ ];
    };

    "org/gnome/desktop/wm/preferences" = {
      action-double-click-titlebar = "toggle-maximize";
      action-middle-click-titlebar = "minimize";
      action-right-click-titlebar = "menu";
      audible-bell = true;
      auto-raise = false;
      auto-raise-delay = 500;
      button-layout = ":minimize,maximize,close";
      disable-workarounds = false;
      focus-mode = "click";
      focus-new-windows = "smart";
      mouse-button-modifier = "<Super>";
      num-workspaces = 8;
      raise-on-click = true;
      resize-with-right-button = true;
      titlebar-font = "Rubik 10";
      titlebar-uses-system-font = false;
      visual-bell = false;
      visual-bell-type = "fullscreen-flash";
      workspace-names = [ ];
    };

    "org/gnome/mutter/keybindings" = {
      rotate-monitor = [ "XF86RotateWindows" ];
      switch-monitor = [
        "<Super>p"
        "XF86Display"
      ];
      tab-popup-cancel = [ ];
      tab-popup-select = [ ];
      toggle-tiled-left = [ "<Shift><Super>Left" ];
      toggle-tiled-right = [ "<Shift><Super>Right" ];
    };

    "org/gnome/mutter/wayland/keybindings" = {
      restore-shortcuts = [ ];
      switch-to-session-1 = [ "<Primary><Alt>F1" ];
      switch-to-session-10 = [ "<Primary><Alt>F10" ];
      switch-to-session-11 = [ "<Primary><Alt>F11" ];
      switch-to-session-12 = [ "<Primary><Alt>F12" ];
      switch-to-session-2 = [ "<Primary><Alt>F2" ];
      switch-to-session-3 = [ "<Primary><Alt>F3" ];
      switch-to-session-4 = [ "<Primary><Alt>F4" ];
      switch-to-session-5 = [ "<Primary><Alt>F5" ];
      switch-to-session-6 = [ "<Primary><Alt>F6" ];
      switch-to-session-7 = [ "<Primary><Alt>F7" ];
      switch-to-session-8 = [ "<Primary><Alt>F8" ];
      switch-to-session-9 = [ "<Primary><Alt>F9" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom8/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom8" = {
      binding = "<Alt>p";
      command = "pmenu";
      name = "Pass Menu";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>f";
      command = "foot --maximized nvim";
      name = "Foot";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Alt><Super>KP_End";
      command = "brave-browser --profile-directory=\"Profile 1\"";
      name = "Brave DevEnv";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Alt><Super>KP_Down";
      command = "brave-browser --profile-directory=\"Profile 2\"";
      name = "Brave DevCtl";
    };

    # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom23" = {
    #   binding = "<Primary><Alt>f";
    #   command = "gnome-terminal --tab-with-profile=fedora-toolbox-37";
    #   name = "Gnome Terminal - fedora-toolbox-37";
    # };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      binding = "<Alt><Super>KP_Next";
      command = "brave-browser --profile-directory=\"Profile 3\"";
      name = "Brave CmdCenter";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
      binding = "<Alt><Super>KP_Left";
      command = "brave-browser --profile-directory=\"Profile 10\"";
      name = "Brave Mask";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" = {
      binding = "";
      command = "firefox -P -no-remote Dev";
      name = "Firefox Dev";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6" = {
      binding = "<Super>KP_Insert";
      command = "wezterm start -- fish -c br";
      name = "Wezterm File";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7" = {
      binding = "<Alt><Super>KP_Enter";
      command = "brave-browser --profile-directory=\"Default\"";
      name = "Brave Home";
    };

    "org/gnome/shell/keybindings" = {
      focus-active-notification = [ "<Super>n" ];
      open-application-menu = [ ];
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
      switch-to-application-5 = [ ];
      switch-to-application-6 = [ ];
      switch-to-application-7 = [ ];
      switch-to-application-8 = [ ];
      switch-to-application-9 = [ ];
      toggle-application-view = [ "<Super>a" ];
      toggle-message-tray = [ "<Super>v" ];
      toggle-overview = [ "<Super>s" ];
      toggle-quick-settings = [ "<Super>e" ];
    };
  };
}
