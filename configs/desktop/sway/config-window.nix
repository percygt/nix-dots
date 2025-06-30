{
  wayland.windowManager.sway.config.window = {
    titlebar = false;
    border = 1;
  };
  modules.desktop.sway.floatingRules = [
    {
      command = ''resize set width 80ppt height 80ppt, move position center'';
      criterias = [
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
