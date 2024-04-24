{
  window = {
    titlebar = false;
    border = 0;
    commands = [
      {
        command = ''move container to workspace 1'';
        criteria = {app_id = "org.wezfurlong.wezterm";};
      }
      # {
      #   command = ''move container to workspace 2'';
      #   criteria = {class = "brave-browser";};
      # }
      {
        command = ''move container to workspace 4'';
        criteria = {app_id = "org.gnome.Nautilus";};
      }
      {
        command = ''move container to workspace 5'';
        criteria = {app_id = "org.keepassxc.KeePassXC";};
      }
    ];
  };
}
