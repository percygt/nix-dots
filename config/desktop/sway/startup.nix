{
  wayland.windowManager.sway.config.startup = [
    {
      command = "systemctl --user restart kanshi";
      always = true;
    }
    { command = "systemctl --user start wlsunset"; }
    { command = "autotiling"; }
    # { command = "systemctl --user start foot"; }
    # {
    #   command = "tmux start-server";
    #   always = true;
    # }
  ];
}
