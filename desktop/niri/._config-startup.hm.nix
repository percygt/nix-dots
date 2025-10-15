{
  programs.niri.settings.spawn-at-startup = [
    {
      command = [
        "systemctl"
        "--user"
        "reset-failed"
        "waybar.service"
      ];
    }
    {
      command = [
        "hyprlock"
      ];
    }
    {
      command = [
        "foot"
        "--server"
      ];
    }
    {
      command = [
        "tmux"
        "start-server"
      ];
    }
  ];
}
