{lib, ...}: {
  xdg.configFile."pop-shell/config.json".text = builtins.toJSON (import ./pop-shell.nix).config;
  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/shell/extensions/just-perfection" = {
      animation = 4;
    };

    "org/gnome/shell/extensions/caffeine" = {
      enable-fullscreen = false;
      toggle-state = false;
    };

    "org/gnome/shell/extensions/blur-my-shell/applications" = {
      blur = false;
      enable-all = true;
    };
    "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
      blur = false;
    };
    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      blur = false;
    };

    "org/gnome/shell/extensions/quake-mode" = {
      quake-mode-always-on-top = false;
      quake-mode-animation-time = 0.19999999999999996;
      quake-mode-gap = 0;
      quake-mode-height = 100;
      quake-mode-hide-from-overview = true;
      quake-mode-monitor = 1;
      quake-mode-tray = false;
      quake-mode-width = 100;
    };

    "org/gnome/shell/extensions/quake-mode/apps" = {
      quake-mode-accelerator-1 = ["<Super>w"];
      quake-mode-accelerator-2 = ["<Super><Shift>f"];
    };

    "org/gnome/shell/extensions/quake-mode/accelerators" = {
      app-1 = "org.wezfurlong.wezterm.desktop";
      app-2 = "org.codeberg.dnkl.foot.desktop";
    };

    "org/gnome/shell/extensions/Battery-Health-Charging" = {
      amend-power-indicator = true;
      charging-mode = "bal";
      ctl-path = "/usr/local/bin/batteryhealthchargingctl-percygt";
      default-threshold = true;
      device-type = 1;
      dummy-apply-threshold = true;
      dummy-default-threshold = true;
      icon-style-type = 1;
      indicator-position-max = 2;
      install-service = 0;
      polkit-installation-changed = true;
      polkit-status = "installed";
      root-mode = true;
      show-battery-panel2 = false;
      show-notifications = true;
      show-preferences = true;
      show-system-indicator = true;
    };

    "org/gnome/shell/extensions/appindicator" = {
      icon-brightness = 0.20000000000000004;
      icon-contrast = 0.6;
      icon-opacity = 200;
      icon-saturation = 0.9999999999999999;
      icon-size = 14;
      legacy-tray-enabled = true;
    };

    "org/gnome/shell/extensions/dash-to-panel" = {
      animate-appicon-hover = true;
      app-ctrl-hotkey-1 = ["<Control><Alt><Super>1"];
      app-ctrl-hotkey-10 = ["<Control><Alt><Super>0"];
      app-ctrl-hotkey-2 = ["<Control><Alt><Super>2"];
      app-ctrl-hotkey-3 = ["<Control><Alt><Super>3"];
      app-ctrl-hotkey-4 = ["<Control><Alt><Super>4"];
      app-ctrl-hotkey-5 = ["<Control><Alt><Super>5"];
      app-ctrl-hotkey-6 = ["<Control><Alt><Super>6"];
      app-ctrl-hotkey-7 = ["<Control><Alt><Super>7"];
      app-ctrl-hotkey-8 = ["<Control><Alt><Super>8"];
      app-ctrl-hotkey-9 = ["<Control><Alt><Super>9"];
      app-ctrl-hotkey-kp-1 = ["<Control><Alt><Super>KP_1"];
      app-ctrl-hotkey-kp-10 = ["<Control><Alt><Super>KP_0"];
      app-ctrl-hotkey-kp-2 = ["<Control><Alt><Super>KP_2"];
      app-ctrl-hotkey-kp-3 = ["<Control><Alt><Super>KP_3"];
      app-ctrl-hotkey-kp-4 = ["<Control><Alt><Super>KP_4"];
      app-ctrl-hotkey-kp-5 = ["<Control><Alt><Super>KP_5"];
      app-ctrl-hotkey-kp-6 = ["<Control><Alt><Super>KP_6"];
      app-ctrl-hotkey-kp-7 = ["<Control><Alt><Super>KP_7"];
      app-ctrl-hotkey-kp-8 = ["<Control><Alt><Super>KP_8"];
      app-ctrl-hotkey-kp-9 = ["<Control><Alt><Super>KP_9"];
      app-hotkey-1 = ["<Alt><Super>1"];
      app-hotkey-10 = ["<Alt><Super>0"];
      app-hotkey-2 = ["<Alt><Super>2"];
      app-hotkey-3 = ["<Alt><Super>3"];
      app-hotkey-4 = ["<Alt><Super>4"];
      app-hotkey-5 = ["<Alt><Super>5"];
      app-hotkey-6 = ["<Alt><Super>6"];
      app-hotkey-7 = ["<Alt><Super>7"];
      app-hotkey-8 = ["<Alt><Super>8"];
      app-hotkey-9 = ["<Alt><Super>9"];
      app-hotkey-kp-1 = ["<Alt><Super>KP_1"];
      app-hotkey-kp-10 = ["<Alt><Super>KP_0"];
      app-hotkey-kp-2 = ["<Alt><Super>KP_2"];
      app-hotkey-kp-3 = ["<Alt><Super>KP_3"];
      app-hotkey-kp-4 = ["<Alt><Super>KP_4"];
      app-hotkey-kp-5 = ["<Alt><Super>KP_5"];
      app-hotkey-kp-6 = ["<Alt><Super>KP_6"];
      app-hotkey-kp-7 = ["<Alt><Super>KP_7"];
      app-hotkey-kp-8 = ["<Alt><Super>KP_8"];
      app-hotkey-kp-9 = ["<Alt><Super>KP_9"];
      app-shift-hotkey-1 = ["<Shift><Alt><Super>1"];
      app-shift-hotkey-10 = ["<Shift><Alt><Super>0"];
      app-shift-hotkey-2 = ["<Shift><Alt><Super>2"];
      app-shift-hotkey-3 = ["<Shift><Alt><Super>3"];
      app-shift-hotkey-4 = ["<Shift><Alt><Super>4"];
      app-shift-hotkey-5 = ["<Shift><Alt><Super>5"];
      app-shift-hotkey-6 = ["<Shift><Alt><Super>6"];
      app-shift-hotkey-7 = ["<Shift><Alt><Super>7"];
      app-shift-hotkey-8 = ["<Shift><Alt><Super>8"];
      app-shift-hotkey-9 = ["<Shift><Alt><Super>9"];
      app-shift-hotkey-kp-1 = ["<Shift><Alt><Super>KP_1"];
      app-shift-hotkey-kp-10 = ["<Shift><Alt><Super>KP_0"];
      app-shift-hotkey-kp-2 = ["<Shift><Alt><Super>KP_2"];
      app-shift-hotkey-kp-3 = ["<Shift><Alt><Super>KP_3"];
      app-shift-hotkey-kp-4 = ["<Shift><Alt><Super>KP_4"];
      app-shift-hotkey-kp-5 = ["<Shift><Alt><Super>KP_5"];
      app-shift-hotkey-kp-6 = ["<Shift><Alt><Super>KP_6"];
      app-shift-hotkey-kp-7 = ["<Shift><Alt><Super>KP_7"];
      app-shift-hotkey-kp-8 = ["<Shift><Alt><Super>KP_8"];
      app-shift-hotkey-kp-9 = ["<Shift><Alt><Super>KP_9"];
      appicon-margin = 0;
      appicon-padding = 6;
      available-monitors = [1 0];
      desktop-line-use-custom-color = false;
      dot-position = "TOP";
      dot-style-focused = "SQUARES";
      dot-style-unfocused = "SQUARES";
      group-apps = true;
      hide-overview-on-startup = true;
      hot-keys = true;
      hotkey-prefix-text = "SuperAlt";
      hotkeys-overlay-combo = "TEMPORARILY";
      intellihide = false;
      intellihide-behaviour = "MAXIMIZED_WINDOWS";
      intellihide-hide-from-windows = true;
      intellihide-key-toggle = ["<Super>i"];
      isolate-monitors = false;
      isolate-workspaces = false;
      leftbox-padding = -1;
      leftbox-size = 14;
      multi-monitors = false;
      overview-click-to-exit = true;
      panel-anchors = ''
        {"0":"MIDDLE","1":"MIDDLE"}
      '';
      panel-element-positions = ''
        {"0":[{"element":"showAppsButton","visible":false,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":true,"position":"centered"},{"element":"dateMenu","visible":true,"position":"centerMonitor"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":false,"position":"stackedBR"}],"1":[{"element":"showAppsButton","visible":false,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":true,"position":"centered"},{"element":"dateMenu","visible":true,"position":"centerMonitor"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":false,"position":"stackedBR"}]}
      '';
      panel-lengths = ''
        {"0":100,"1":100}
      '';
      panel-positions = ''
        {"0":"TOP","1":"TOP"}
      '';
      panel-sizes = ''
        {"0":28,"1":28}
      '';
      primary-monitor = 1;
      progress-show-count = false;
      secondarymenu-contains-showdetails = true;
      shortcut = ["<Super>q"];
      show-apps-icon-file = "/home/percygt/Pictures/Wallpaper/bg.jpg";
      show-apps-icon-side-padding = 0;
      show-favorites = true;
      show-favorites-all-monitors = false;
      show-running-apps = true;
      show-window-previews = true;
      status-icon-padding = 6;
      stockgs-keep-dash = false;
      stockgs-panelbtn-click-only = true;
      trans-bg-color = "#000000";
      trans-dynamic-anim-target = 0.1;
      trans-dynamic-distance = 10;
      trans-gradient-bottom-color = "#000000";
      trans-gradient-bottom-opacity = 0.2;
      trans-gradient-top-color = "#000000";
      trans-gradient-top-opacity = 0.8;
      trans-panel-opacity = 0.2;
      trans-use-custom-bg = true;
      trans-use-custom-gradient = true;
      trans-use-custom-opacity = true;
      trans-use-dynamic-opacity = true;
      tray-padding = 4;
      tray-size = 14;
      window-preview-title-position = "TOP";
    };

    "org/gnome/shell/extensions/date-menu-formatter" = {
      apply-all-panels = true;
      font-size = 10;
      pattern = "MM.dd.yy' 🌣 'hh:mm:ss";
      remove-messages-indicator = true;
      use-default-locale = true;
    };

    "org/gnome/shell/extensions/docker" = {
      logo = "white";
      menu-type = "icons";
      show-information = true;
      show-ports = true;
      submenu-image = 10;
      submenu-text = 14;
      terminal = "/home/percygt/.local/share/gnome-shell/extensions/ddterm@amezin.github.com/bin/com.github.amezin.ddterm -- sh -c";
    };

    "org/gnome/shell/extensions/executor" = {
      center-active = false;
      center-commands-json = "{\"commands\":[{\"isActive\":false,\"command\":\"date \\\"+%m.%d.%y\\\" | while read var_date; do echo \\\"<span foreground='#aae1ec' font_desc='Rubik 10'>$var_date</span><executor.markup.true>\\\"; done \",\"interval\":86400,\"uuid\":\"85c5d317-23df-4e5b-b9ef-f5f04e754591\"},{\"isActive\":false,\"command\":\"echo '    '\",\"interval\":86400,\"uuid\":\"835b7ea3-e025-427d-a7c9-fc55c66d2e22\"},{\"isActive\":false,\"command\":\"date \\\"+%p\\\" | awk '{if ($1==\\\"AM\\\") {print \\\" <span font_desc=\\\\\\\"JetBrains Mono Nerd Font 9\\\\\\\" foreground=\\\\\\\"#ffdf89\\\\\\\">\61829</span><executor.markup.true>\\\" } else {print \\\" <span font_desc=\\\\\\\"JetBrains Mono Nerd Font 10\\\\\\\" foreground=\\\\\\\"#ff8d80\\\\\\\">\986978</span><executor.markup.true>\\\"}}'\",\"interval\":86400,\"uuid\":\"9dafa898-417f-437c-a3fc-75c7511db8a1\"},{\"isActive\":false,\"command\":\"echo '   '\",\"interval\":86400,\"uuid\":\"b70a31cc-7194-4557-9c1a-1edd189a58d0\"},{\"isActive\":false,\"command\":\"date \\\"+%I:%M:%S\\\"  | while read var_time; do echo \\\"<span foreground='#aae1ec' font_desc='Rubik 10'>$var_time</span><executor.markup.true>\\\"; done \",\"interval\":1,\"uuid\":\"fd03c0cf-4e22-4628-b7fc-57d44b573f8d\"},{\"isActive\":false,\"command\":\"watch -t -n 1 date +%I\",\"interval\":1,\"uuid\":\"ac0db238-95e3-4b24-bbf6-aee253fc54bb\"},{\"isActive\":true,\"command\":\"[[ $(protonvpn s | grep Status | awk '{print $2}') == 'Disconnected' ]] && echo hey\",\"interval\":1,\"uuid\":\"fd041aef-f59d-4d98-ba90-867346f28bda\"}]}";
      center-index = 0;
      click-on-output-active = true;
      left-active = false;
      left-commands-json = "{\"commands\":[{\"isActive\":true,\"command\":\"bluetoothctl devices Connected | cut -f2 -d' ' | while read uuid; do bluetoothctl info $uuid; done | tr -d '()' | awk '/Icon:/{if ($2 == \\\"phone\\\"){print \\\" <span font_desc=\\\\\\\"JetBrains Mono Nerd Font 10\\\\\\\" foreground=\\\\\\\"#ffdf89\\\\\\\">\61707\988171</span>\\\"} else if ($2 == \\\"audio-headphones\\\"){print \\\" <span foreground=\\\\\\\"#ffdf89\\\\\\\" font_desc=\\\\\\\"JetBrains Mono Nerd Font 9\\\\\\\">\989263 </span><executor.markup.true>\\\"}} /Battery Percentage:/{print \\\"<span foreground=\\\\\\\"#aae1ec\\\\\\\" font_desc=\\\\\\\"Rubik 10\\\\\\\">\\\"$4\\\"%   \\\"\\\"</span><executor.markup.true>\\\"}'\",\"interval\":1,\"uuid\":\"95df7f3a-970d-4c98-bf85-91412ddbab3c\"},{\"isActive\":true,\"command\":\"free | awk '/Mem/{printf(\\\"%.0f\\\"), $3/($2+.000000001)*100}' | awk '{printf(\\\" <span font_desc=\\\\\\\"JetBrains Mono Nerd Font 10\\\\\\\" foreground=\\\\\\\"#ffdf89\\\\\\\">\983899</span><span foreground=\\\\\\\"#aae1ec\\\\\\\" font_desc=\\\\\\\"Rubik 10\\\\\\\"> \\\"$1\\\"%  \\\"\\\"</span><executor.markup.true>\\\")}'\",\"interval\":1,\"uuid\":\"7d885dd8-5e61-4d1c-81e3-bac8745e5d47\"},{\"isActive\":true,\"command\":\"nmcli con | awk -F\\\"[ \\\\t-]*\\\" '/ProtonVPN/{if ($9 == \\\"vpn\\\") {print \\\" <span font_desc=\\\\\\\"JetBrains Mono Nerd Font 10\\\\\\\" foreground=\\\\\\\"#ffdf89\\\\\\\">\984196</span> <span font_desc=\\\\\\\"JetBrains Mono Nerd Font 10\\\\\\\" foreground=\\\\\\\"#aae1ec\\\\\\\">\\\"$2\\\"</span><executor.markup.true><executor.markup.true>\\\"} else {print \\\" <span foreground=\\\\\\\"#ffdf89\\\\\\\" font_desc=\\\\\\\"JetBrains Mono Nerd Font 9\\\\\\\">\986267</span><executor.markup.true>\\\"}}'\",\"interval\":60,\"uuid\":\"ce6e7be0-2e44-4477-b616-ea77e0e10be3\"}]}";
      left-index = 2;
      location = 2;
      right-active = true;
      right-commands-json = "{\"commands\":[{\"isActive\":true,\"command\":\"bluetoothctl devices Connected | cut -f2 -d' ' | while read uuid; do bluetoothctl info $uuid; done | tr -d '()' | awk '/Icon:/{if ($2 == \\\"phone\\\"){print \\\" <span font_desc=\\\\\\\"JetBrains Mono Nerd Font 10\\\\\\\" foreground=\\\\\\\"#eaeaea\\\\\\\"> \61707\988171</span>\\\"} else if ($2 == \\\"audio-headphones\\\"){print \\\" <span foreground=\\\\\\\"#eaeaea\\\\\\\" font_desc=\\\\\\\"JetBrains Mono Nerd Font 9\\\\\\\">\989263</span>\\\"}} /Battery Percentage:/{print \\\"<span foreground=\\\\\\\"#eaeaea\\\\\\\" font_desc=\\\\\\\"Rubik 10\\\\\\\"> \\\"$4\\\"% \\\"\\\"</span><executor.markup.true>\\\"}'\",\"interval\":1,\"uuid\":\"68fabe0e-cf2c-4d5d-b233-4f4ece78fd1a\"},{\"isActive\":false,\"command\":\"free | awk '/Mem/{printf(\\\"%.0f\\\"), $3/($2+.000000001)*100}' | awk '{printf(\\\" <span font_desc=\\\\\\\"JetBrains Mono Nerd Font 10\\\\\\\" foreground=\\\\\\\"#eaeaea\\\\\\\">\983899</span><span foreground=\\\\\\\"#eaeaea\\\\\\\" font_desc=\\\\\\\"Rubik 10\\\\\\\"> \\\"$1\\\"%\\\"   \\\"</span><executor.markup.true>\\\")}'\",\"interval\":1,\"uuid\":\"16a6fb1e-89bc-42c9-ab59-c64ec9b1fb1b\"},{\"isActive\":false,\"command\":\"nmcli con | awk -F\\\"[ \\\\t-]*\\\" '/ProtonVPN/{if ($9 == \\\"vpn\\\") {print \\\" <span font_desc=\\\\\\\"JetBrains Mono Nerd Font 10\\\\\\\" foreground=\\\\\\\"#eaeaea\\\\\\\"> \984196</span> <span font_desc=\\\\\\\"JetBrains Mono Nerd Font 10\\\\\\\" foreground=\\\\\\\"#eaeaea\\\\\\\">\\\" $2  \\\" </span><executor.markup.true>\\\"} else {print \\\" <span foreground=\\\\\\\"#eaeaea\\\\\\\" font_desc=\\\\\\\"JetBrains Mono Nerd Font 9\\\\\\\">\986267  </span><executor.markup.true>\\\"}}'\",\"interval\":1,\"uuid\":\"5158eda1-b86c-4e2b-89af-e66436b69c09\"}]}";
      right-index = 0;
    };


    "org/gnome/shell/extensions/focus-follows-workspace" = {
      move-cursor = false;
    };

    "org/gnome/shell/extensions/forge" = {
      auto-split-enabled = true;
      css-last-update = mkUint32 37;
      css-updated = "1699203346290";
      dnd-center-layout = "stacked";
      focus-border-toggle = false;
      preview-hint-enabled = true;
      stacked-tiling-mode-enabled = false;
      tabbed-tiling-mode-enabled = false;
      tiling-mode-enabled = true;
      window-gap-hidden-on-single = false;
      window-gap-size = mkUint32 1;
      window-gap-size-increment = mkUint32 2;
      workspace-skip-tile = "";
    };

    "org/gnome/shell/extensions/forge/keybindings" = {
      con-split-horizontal = [];
      con-split-layout-toggle = [];
      con-split-vertical = [];
      con-stacked-layout-toggle = [];
      con-tabbed-layout-toggle = [];
      con-tabbed-showtab-decoration-toggle = [];
      focus-border-toggle = [];
      mod-mask-mouse-tile = "Super";
      prefs-tiling-toggle = ["<Super>w"];
      window-focus-down = ["<Super>Down"];
      window-focus-left = ["<Super>Left"];
      window-focus-right = ["<Super>Right"];
      window-focus-up = ["<Super>Up"];
      window-gap-size-decrease = [];
      window-gap-size-increase = [];
      window-move-down = [];
      window-move-left = [];
      window-move-right = [];
      window-move-up = [];
      window-resize-bottom-decrease = [];
      window-resize-bottom-increase = [];
      window-resize-left-decrease = [];
      window-resize-left-increase = [];
      window-resize-right-decrease = [];
      window-resize-right-increase = [];
      window-resize-top-decrease = [];
      window-resize-top-increase = [];
      window-snap-center = [];
      window-snap-one-third-left = [];
      window-snap-one-third-right = [];
      window-snap-two-third-left = [];
      window-snap-two-third-right = [];
      window-swap-down = [];
      window-swap-last-active = [];
      window-swap-left = [];
      window-swap-right = [];
      window-swap-up = [];
      window-toggle-always-float = ["<Shift><Super>c"];
      window-toggle-float = ["<Super>c"];
      workspace-active-tile-toggle = ["<Shift><Super>w"];
    };

    "org/gnome/shell/extensions/mpris-label" = {
      album-size = 60;
      auto-switch-to-most-recent = true;
      enable-double-clicks = true;
      extension-index = 0;
      extension-place = "right";
      first-field = "xesam:title";
      icon-padding = 0;
      last-field = "xesam:album";
      left-padding = 0;
      max-string-length = 19;
      remove-text-paused-delay = 3;
      reposition-delay = 2;
      reposition-on-button-press = true;
      right-padding = 0;
      second-field = "xesam:artist";
      show-icon = "left";
      symbolic-source-icon = true;
      use-album = true;
    };

    "org/gnome/shell/extensions/panel-date-format" = {
      format = "%y.%m.%d  \9788  %I:%M:%S";
    };

    "org/gnome/shell/extensions/pano" = {
      global-shortcut = ["<Alt><Super>c"];
      incognito-shortcut = ["<Control><Alt><Super>c"];
      is-in-incognito = false;
      paste-on-select = false;
      play-audio-on-copy = true;
      send-notification-on-copy = false;
      sync-primary = false;
      window-background-color = "rgba(22,25,37,0.453333)";
      window-height = 325;
    };

    "org/gnome/shell/extensions/pano/code-item" = {
      body-font-family = "Hack Nerd Font";
      body-font-size = 13;
    };

    "org/gnome/shell/extensions/pop-shell" = {
      activate-launcher = [];
      active-hint = false;
      active-hint-border-radius = mkUint32 15;
      gap-inner = mkUint32 1;
      gap-outer = mkUint32 1;
      hint-color-rgba = "rgba(27,29,146,0.657718)";
      management-orientation = [];
      pop-monitor-down = [];
      pop-monitor-left = [];
      pop-monitor-right = [];
      pop-monitor-up = [];
      pop-workspace-down = [];
      pop-workspace-up = [];
      tile-accept = [];
      tile-by-default = true;
      tile-enter = [];
      tile-move-down = [];
      tile-move-left = [];
      tile-move-left-global = [];
      tile-move-right = [];
      tile-move-right-global = [];
      tile-move-up = [];
      tile-orientation = [];
      tile-reject = [];
      tile-resize-down = [];
      tile-resize-left = [];
      tile-resize-right = [];
      tile-resize-up = [];
      tile-swap-down = [];
      tile-swap-left = [];
      tile-swap-right = [];
      tile-swap-up = [];
      toggle-stacking = [];
      toggle-stacking-global = [];
    };

    "org/gnome/shell/extensions/quick-settings-tweaks" = {
      add-dnd-quick-toggle-enabled = false;
      add-unsafe-quick-toggle-enabled = false;
      datemenu-fix-weather-widget = false;
      datemenu-remove-media-control = true;
      datemenu-remove-notifications = false;
      disable-adjust-content-border-radius = false;
      disable-remove-shadow = false;
      input-always-show = true;
      input-show-selected = false;
      list-buttons = "[{\"name\":\"SystemItem\",\"title\":null,\"visible\":true},{\"name\":\"OutputStreamSlider\",\"title\":null,\"visible\":true},{\"name\":\"InputStreamSlider\",\"title\":null,\"visible\":false},{\"name\":\"BrightnessItem\",\"title\":null,\"visible\":true},{\"name\":\"NMWiredToggle\",\"title\":\"Wired\",\"visible\":true},{\"name\":\"NMWirelessToggle\",\"title\":\"Wi-Fi\",\"visible\":true},{\"name\":\"NMModemToggle\",\"title\":null,\"visible\":false},{\"name\":\"NMBluetoothToggle\",\"title\":null,\"visible\":false},{\"name\":\"NMVpnToggle\",\"title\":null,\"visible\":false},{\"name\":\"BluetoothToggle\",\"title\":\"Bluetooth\",\"visible\":true},{\"name\":\"PowerProfilesToggle\",\"title\":\"Power Mode\",\"visible\":true},{\"name\":\"NightLightToggle\",\"title\":\"Night Light\",\"visible\":true},{\"name\":\"DarkModeToggle\",\"title\":\"Dark Style\",\"visible\":true},{\"name\":\"KeyboardBrightnessToggle\",\"title\":\"Keyboard\",\"visible\":true},{\"name\":\"RfkillToggle\",\"title\":\"Airplane Mode\",\"visible\":true},{\"name\":\"RotationToggle\",\"title\":\"Auto Rotate\",\"visible\":false},{\"name\":\"ShutdownTimerItem\",\"title\":\"Power Off\",\"visible\":true},{\"name\":\"ChargeLimitToggle\",\"title\":\"Battery\",\"visible\":true},{\"name\":\"CaffeineToggle\",\"title\":\"Caffeine\",\"visible\":true},{\"name\":\"ServiceToggle\",\"title\":\"GSConnect\",\"visible\":true},{\"name\":\"BackgroundAppsToggle\",\"title\":\"No Background Apps\",\"visible\":false}]";
      media-control-compact-mode = false;
      media-control-enabled = false;
      notifications-enabled = false;
      notifications-hide-when-no-notifications = true;
      notifications-integrated = true;
      notifications-use-native-controls = true;
      output-show-selected = false;
      user-removed-buttons = ["NMBluetoothToggle" "RotationToggle" "BackgroundAppsToggle" "DarkModeToggle"];
      volume-mixer-check-description = false;
      volume-mixer-enabled = false;
      volume-mixer-position = "bottom";
      volume-mixer-show-description = false;
      volume-mixer-show-icon = false;
      volume-mixer-use-regex = false;
    };

    "org/gnome/shell/extensions/shutdowntimer-deminder" = {
      auto-wake-value = false;
      preferences-selected-page-value = 2;
      root-mode-value = true;
      shutdown-max-timer-value = 60;
      shutdown-mode-value = "poweroff";
      shutdown-slider-value = 52.84852372839096;
      shutdown-timestamp-value = -1;
      wake-max-timer-value = 360;
      wake-ref-timer-value = "shutdown";
      wake-slider-value = 100.0;
    };

    "org/gnome/shell/extensions/space-bar/appearance" = {
      active-workspace-background-color = "rgb(255,255,255,0.25)";
      active-workspace-border-color = "rgb(36,31,49)";
      active-workspace-border-radius = 2;
      active-workspace-border-width = 0;
      active-workspace-font-weight = "500";
      active-workspace-padding-h = 6;
      active-workspace-padding-v = 2;
      active-workspace-text-color = "rgb(249,240,107)";
      empty-workspace-border-radius = 2;
      empty-workspace-border-width = 0;
      empty-workspace-font-weight = "100";
      empty-workspace-padding-h = 6;
      empty-workspace-padding-v = 2;
      inactive-workspace-border-radius = 0;
      inactive-workspace-border-width = 0;
      inactive-workspace-font-weight = "100";
      inactive-workspace-font-weight-active = true;
      inactive-workspace-padding-h = 6;
      inactive-workspace-padding-v = 2;
      inactive-workspace-text-color = "rgba(255,255,255,0.25)";
      workspace-margin = 4;
      workspaces-bar-padding = 2;
    };

    "org/gnome/shell/extensions/space-bar/behavior" = {
      always-show-numbers = true;
      indicator-style = "workspaces-bar";
      position-index = 0;
      smart-workspace-names = false;
    };

    "org/gnome/shell/extensions/space-bar/shortcuts" = {
      activate-empty-key = [];
      activate-previous-key = [];
      enable-activate-workspace-shortcuts = false;
      enable-move-to-workspace-shortcuts = false;
      move-workspace-left = [];
      move-workspace-right = [];
      open-menu = [];
    };

    "org/gnome/shell/extensions/rounded-window-corners" = {
      black-list = [
        "com.github.amezin.ddterm"
        "org.wezfurlong.wezterm"
        "foot"
      ];
      border-color = mkTuple [
        (mkDouble 0.0039215651340782642)
        (mkDouble 0.082352980971336365)
        (mkDouble 0.17254902422428131)
        (mkDouble 0.79666668176651001)
      ];
      border-width = 2;
      enable-preferences-entry = true;
      focused-shadow = [
        (mkDictionaryEntry ["vertical_offset" 0])
        (mkDictionaryEntry ["horizontal_offset" 0])
        (mkDictionaryEntry ["blur_offset" 16])
        (mkDictionaryEntry ["spread_radius" 3])
        (mkDictionaryEntry ["opacity" 85])
      ];
      global-rounded-corner-settings = [
        (mkDictionaryEntry
          [
            "padding"
            (
              mkVariant [
                (mkDictionaryEntry ["left" (mkVariant (mkUint32 0))])
                (mkDictionaryEntry ["right" (mkVariant (mkUint32 0))])
                (mkDictionaryEntry ["top" (mkVariant (mkUint32 0))])
                (mkDictionaryEntry ["bottom" (mkVariant (mkUint32 0))])
              ]
            )
          ])
        (mkDictionaryEntry
          [
            "keep_rounded_corners"
            (
              mkVariant [
                (mkDictionaryEntry ["maximized" (mkVariant false)])
                (mkDictionaryEntry ["fullscreen" (mkVariant false)])
              ]
            )
          ])
        (mkDictionaryEntry
          [
            "border_radius"
            (mkVariant (mkUint32 12))
          ])
        (mkDictionaryEntry
          [
            "smoothing"
            (mkVariant 0.5)
          ])
        (mkDictionaryEntry
          [
            "enabled"
            (mkVariant true)
          ])
      ];
      settings-version = mkUint32 5;
      skip-libadwaita-app = false;
      skip-libhandy-app = false;
      tweak-kitty-terminal = true;
      unfocused-shadow = [
        (mkDictionaryEntry ["vertical_offset" 0])
        (mkDictionaryEntry ["horizontal_offset" 0])
        (mkDictionaryEntry ["blur_offset" 16])
        (mkDictionaryEntry ["spread_radius" 16])
        (mkDictionaryEntry ["opacity" 60])
      ];
    };

    "org/gnome/shell/extensions/systemd-manager" = {
      systemd = [
        ''
          {"name":"Flatpak Update","service":"flatpak-automatic.service","type":"system"}
        ''
        ''
          {"name":"Daily Backup","service":"daily-data-backup.service","type":"system"}
        ''
      ];
    };


    "org/gnome/shell/extensions/vertical-workspaces" = {
      aaa-loading-profile = true;
      always-activate-selected-window = true;
      always-show-win-titles = true;
      animation-speed-factor = 70;
      app-display-module = true;
      app-favorites-module = true;
      app-grid-active-preview = false;
      app-grid-animation = 4;
      app-grid-bg-blur-sigma = 25;
      app-grid-columns = 8;
      app-grid-content = 4;
      app-grid-folder-center = false;
      app-grid-folder-columns = 0;
      app-grid-folder-icon-grid = 2;
      app-grid-folder-icon-size = -1;
      app-grid-folder-rows = 0;
      app-grid-icon-size = 112;
      app-grid-incomplete-pages = false;
      app-grid-names = 0;
      app-grid-order = 0;
      app-grid-page-width-scale = 100;
      app-grid-rows = 4;
      app-grid-spacing = 12;
      center-app-grid = false;
      center-dash-to-ws = false;
      center-search = true;
      close-ws-button-mode = 1;
      dash-bg-color = 0;
      dash-bg-gs3-style = false;
      dash-bg-opacity = 0;
      dash-bg-radius = 0;
      dash-icon-scroll = 1;
      dash-max-icon-size = 64;
      dash-module = true;
      dash-position = 0;
      dash-position-adjust = 0;
      dash-show-recent-files-icon = 0;
      dash-show-windows-before-activation = 0;
      dash-show-windows-icon = 0;
      enable-page-shortcuts = true;
      favorites-notify = 1;
      fix-ubuntu-dock = false;
      hot-corner-action = 0;
      hot-corner-fullscreen = false;
      hot-corner-position = 0;
      hot-corner-ripples = false;
      layout-module = false;
      message-tray-module = true;
      new-window-focus-fix = true;
      notification-position = 2;
      osd-position = 6;
      osd-window-module = true;
      overlay-key-module = true;
      overlay-key-primary = 2;
      overlay-key-secondary = 0;
      overview-bg-blur-sigma = 25;
      overview-bg-brightness = 95;
      overview-esc-behavior = 1;
      overview-mode = 2;
      panel-module = true;
      panel-position = 0;
      panel-visibility = 0;
      profile-data-1 = [
        ["mkTupleworkspaceThumbnailsPosition" "5"]
        ["wsMaxSpacing" "350"]
        ["wsPreviewScale" "100"]
        ["secWsPreviewScale" "100"]
        ["secWsPreviewShift" "false"]
        ["wsThumbnailsFull" "true"]
        ["secWsThumbnailsPosition" "2"]
        ["dashPosition" "0"]
        ["dashPositionAdjust" "0"]
        ["wsTmbPositionAdjust" "0"]
        ["showWsTmbLabels" "0"]
        ["showWsTmbLabelsOnHover" "false"]
        ["closeWsButtonMode" "1"]
        ["secWsTmbPositionAdjust" "0"]
        ["dashMaxIconSize" "64"]
        ["dashShowWindowsIcon" "0"]
        ["dashShowRecentFilesIcon" "0"]
        ["dashShowExtensionsIcon" "1"]
        ["centerDashToWs" "false"]
        ["showAppsIconPosition" "2"]
        ["wsThumbnailScale" "17"]
        ["wsThumbnailScaleAppGrid" "17"]
        ["secWsThumbnailScale" "13"]
        ["showSearchEntry" "true"]
        ["centerSearch" "true"]
        ["centerAppGrid" "false"]
        ["dashBgOpacity" "0"]
        ["dashBgColor" "0"]
        ["dashBgRadius" "0"]
        ["dashBgGS3Style" "false"]
        ["runningDotStyle" "1"]
        ["enablePageShortcuts" "true"]
        ["showWsSwitcherBg" "false"]
        ["showWsPreviewBg" "false"]
        ["wsPreviewBgRadius" "29"]
        ["showBgInOverview" "true"]
        ["overviewBgBrightness" "95"]
        ["searchBgBrightness" "30"]
        ["overviewBgBlurSigma" "25"]
        ["appGridBgBlurSigma" "25"]
        ["smoothBlurTransitions" "true"]
        ["appGridAnimation" "4"]
        ["searchViewAnimation" "0"]
        ["workspaceAnimation" "1"]
        ["animationSpeedFactor" "70"]
        ["winPreviewIconSize" "0"]
        ["winTitlePosition" "0"]
        ["startupState" "1"]
        ["overviewMode" "2"]
        ["workspaceSwitcherAnimation" "0"]
        ["searchIconSize" "96"]
        ["searchViewScale" "100"]
        ["appGridIconSize" "112"]
        ["appGridColumns" "8"]
        ["appGridRows" "4"]
        ["appGridFolderIconSize" "-1"]
        ["appGridFolderColumns" "0"]
        ["appGridFolderRows" "0"]
        ["appGridFolderIconGrid" "2"]
        ["appGridContent" "4"]
        ["appGridIncompletePages" "false"]
        ["appGridOrder" "0"]
        ["appFolderOrder" "0"]
        ["appGridNamesMode" "0"]
        ["appGridActivePreview" "false"]
        ["appGridFolderCenter" "false"]
        ["appGridPageWidthScale" "100"]
        ["appGridSpacing" "12"]
        ["searchWindowsOrder" "1"]
        ["searchFuzzy" "true"]
        ["searchMaxResultsRows" "5"]
        ["dashShowWindowsBeforeActivation" "1"]
        ["dashIconScroll" "1"]
        ["dashIsolateWorkspaces" "false"]
        ["searchWindowsIconScroll" "1"]
        ["panelVisibility" "0"]
        ["panelPosition" "0"]
        ["windowAttentionMode" "0"]
        ["wsSwPopupHPosition" "50"]
        ["wsSwPopupVPosition" "50"]
        ["wsSwPopupMode" "0"]
        ["wsSwitcherWraparound" "false"]
        ["wsSwitcherIgnoreLast" "false"]
        ["favoritesNotify" "1"]
        ["notificationPosition" "2"]
        ["osdPosition" "6"]
        ["hotCornerAction" "0"]
        ["hotCornerPosition" "0"]
        ["hotCornerFullscreen" "false"]
        ["hotCornerRipples" "false"]
        ["alwaysActivateSelectedWindow" "true"]
        ["winPreviewSecBtnAction" "1"]
        ["winPreviewMidBtnAction" "3"]
        ["winPreviewShowCloseButton" "true"]
        ["windowIconClickAction" "1"]
        ["overlayKeyPrimary" "2"]
        ["overlayKeySecondary" "0"]
        ["overviewEscBehavior" "1"]
        ["newWindowFocusFix" "true"]
        ["appGridPerformance" "true"]
        ["windowThumbnailScale" "25"]
        ["workspaceSwitcherPopupModule" "true"]
        ["workspaceAnimationModule" "true"]
        ["workspaceModule" "true"]
        ["windowManagerModule" "true"]
        ["windowPreviewModule" "true"]
        ["windowAttentionHandlerModule" "true"]
        ["windowThumbnailModule" "true"]
        ["swipeTrackerModule" "true"]
        ["searchControllerModule" "true"]
        ["searchModule" "true"]
        ["panelModule" "false"]
        ["overlayKeyModule" "true"]
        ["osdWindowModule" "true"]
        ["messageTrayModule" "true"]
        ["layoutModule" "false"]
        ["dashModule" "true"]
        ["appFavoritesModule" "true"]
        ["appDisplayModule" "true"]
        ["windowSearchProviderModule" "true"]
        ["recentFilesSearchProviderModule" "true"]
        ["extensionsSearchProviderModule" "true"]
      ];

      profile-name-1 = "GNOME45";
      recent-files-search-provider-module = true;
      search-controller-module = true;
      search-fuzzy = true;
      search-icon-size = 96;
      search-max-results-rows = 5;
      search-module = true;
      search-recent-files-enable = true;
      search-view-animation = 0;
      search-width-scale = 100;
      search-windows-enable = true;
      search-windows-icon-scroll = 1;
      search-windows-order = 1;
      sec-wst-position-adjust = 0;
      secondary-ws-preview-scale = 100;
      secondary-ws-preview-shift = false;
      secondary-ws-thumbnail-scale = 13;
      secondary-ws-thumbnails-position = 2;
      show-app-icon-position = 2;
      show-bg-in-overview = true;
      show-search-entry = true;
      show-ws-preview-bg = false;
      show-ws-switcher-bg = false;
      show-wst-labels = 0;
      show-wst-labels-on-hover = false;
      smooth-blur-transitions = true;
      startup-state = 1;
      swipe-tracker-module = true;
      win-attention-handler-module = true;
      win-preview-icon-size = 0;
      win-preview-mid-mouse-btn-action = 3;
      win-preview-sec-mouse-btn-action = 1;
      win-preview-show-close-button = true;
      win-title-position = 0;
      window-attention-mode = 0;
      window-icon-click-action = 1;
      window-icon-click-search = true;
      window-manager-module = true;
      window-preview-module = true;
      window-search-provider-module = true;
      window-thumbnail-module = true;
      window-thumbnail-scale = 25;
      workspace-animation = 1;
      workspace-animation-module = true;
      workspace-module = true;
      workspace-switcher-animation = 0;
      workspace-switcher-popup-module = true;
      workspace-thumbnails-module = true;
      ws-max-spacing = 350;
      ws-preview-bg-radius = 29;
      ws-preview-scale = 100;
      ws-sw-popup-h-position = 50;
      ws-sw-popup-mode = 0;
      ws-sw-popup-v-position = 50;
      ws-switcher-ignore-last = false;
      ws-switcher-wraparound = false;
      ws-thumbnail-scale = 17;
      ws-thumbnail-scale-appgrid = 17;
      ws-thumbnails-full = true;
      ws-thumbnails-position = 5;
      wst-position-adjust = 0;
    };
  };
}
