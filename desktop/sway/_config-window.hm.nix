{
  wayland.windowManager.sway.config.window = {
    titlebar = false;
    border = 1;
  };
  modules.desktop.sway.floatingRules = [
    {
      command = ''border none, floating enable'';
      criterias = [ { class = ".scrcpy-wrapped"; } ];
    }
    {
      command = ''resize set width 30ppt height 60ppt, move position center'';
      criterias = [ { app_id = "org.gnome.Calculator"; } ];
    }
    {
      command = ''resize set width 90ppt height 90ppt, move position center'';
      criterias = [
        { app_id = "org.gnome.Shotwell"; }
        { app_id = "org.gnome.Snapshot"; }
        { app_id = "mpv"; }
      ];
    }
    {
      command = ''resize set width 80ppt height 80ppt, move position center'';
      criterias = [
        { app_id = "org.keepassxc.KeePassXC"; }
        { app_id = "gnome-disks"; }
        { app_id = "lollypop"; }
        { app_id = "io.github.dvlv.boxbuddyrs"; }
        { app_id = "org.gnome.Firmware"; }
        { class = "\.?qemu-system-x86_64(-wrapped)?"; }
        { class = "Spotify"; }
        { title = "^Brave$"; }
        {
          title = "^Friends List$";
          class = "steam";
        }
      ];
    }
    {
      command = ''resize set width 50ppt height 50ppt, move position center'';
      criterias = [
        { app_id = "wpa_gui"; }
        {
          app_id = "org.gnome.Nautilus";
          title = "^Properties$";
        }
        { app_id = "nm-connection-editor"; }
        { app_id = "udiskie"; }
      ];
    }
    {
      command = ''resize set width 20ppt height 20ppt, move position 80ppt 80ppt, border none, sticky on'';
      criterias = [
        { title = "^Picture-in-Picture$"; }
        { title = "^Picture in picture$"; }
      ];
    }
  ];
}
