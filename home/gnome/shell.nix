# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{
  lib,
  self,
  config,
  ...
}: let
  ui = import "${self}/lib/mkUI.nix" {inherit config;};
  wallpaper = "file://${ui.themes.wallpaper}";
  shell_theme = "Marble-crispblue-dark";
in {
  xdg.dataFile = {
    "themes/Marble-crispblue-dark" = {
      source = "${self}/lib/assets/themes/Marble-crispblue-dark";
    };
  };
  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/shell/extensions/user-theme" = {
      name = shell_theme;
    };
    "org/gnome/desktop/screensaver" = {
      picture-uri = wallpaper;
    };
    "org/gnome/desktop/background" = {
      picture-uri = wallpaper;
      picture-uri-dark = wallpaper;
    };
    "org/gnome/desktop/input-sources" = {
      # remap capslock to esc
      xkb-options = ["caps:escape"];
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
      titlebar-uses-system-font = true;
    };
    "org/gnome/desktop/interface" = {
      clock-format = "12h";
      clock-show-date = true;
      clock-show-seconds = true;
      clock-show-weekday = true;
      cursor-blink = true;
      cursor-blink-time = 1200;
      cursor-blink-timeout = 10;
      document-font-name = "Noto Sans CJK HK Bold 10";
      enable-animations = true;
      enable-hot-corners = false;
      font-antialiasing = "rgba";
      font-hinting = "full";
      font-rgba-order = "rgb";
      gtk-color-scheme = "";
      gtk-enable-primary-paste = true;
      gtk-im-module = "gtk-im-context-simple";
      gtk-im-preedit-style = "callback";
      gtk-im-status-style = "callback";
      gtk-key-theme = "Default";
      gtk-timeout-initial = 200;
      gtk-timeout-repeat = 20;
      locate-pointer = true;
      menubar-accel = "F10";
      menubar-detachable = false;
      menus-have-icons = false;
      menus-have-tearoff = false;
      monospace-font-name = "JetBrainsMono Nerd Font 10";
      overlay-scrolling = true;
      scaling-factor = mkUint32 0;
      show-battery-percentage = false;
      show-input-method-menu = true;
      show-unicode-menu = true;
      text-scaling-factor = 1.0;
      toolbar-detachable = false;
      toolbar-icons-size = "large";
      toolbar-style = "both-horiz";
      toolkit-accessibility = false;
    };
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "codium.desktop"
        "com.brave.Browser.desktop"
        "firefox.desktop"
        "com.github.tchx84.Flatseal.desktop"
        "org.keepassxc.KeePassXC.desktop"
        "btrfs-assistant.desktop"
        "com.discordapp.Discord.desktop"
        "io.beekeeperstudio.Studio.desktop"
        "org.cockpit_project.CockpitClient.desktop"
        "md.obsidian.Obsidian.desktop"
        "virt-manager.desktop"
      ];
      last-selected-power-profile = "performance";
    };
    "org/gnome/mutter" = {
      # attach-modal-dialogs = true;
      # auto-maximize = false;
      center-new-windows = true;
      dynamic-workspaces = true;
      edge-tiling = false;
      experimental-features = ["scale-monitor-framebuffer"];
      locate-pointer-key = "Control_L";
      overlay-key = "";
      workspaces-only-on-primary = true;
    };
  };
}
