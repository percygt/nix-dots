{
  config,
  ...
}:
let
  a = config.modules.themes.assets;
in
{
  programs.niri.settings.spawn-at-startup = [
    {
      command = [
        "swaybg"
        "-i"
        "${a.wallpaper}"
      ];
    }
    {
      command = [
        "hyprlock"
      ];
    }
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
    # {
    #   command = [
    #     "backlightset"
    #     "max"
    #   ];
    # }
  ];
}
