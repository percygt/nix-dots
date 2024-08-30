{
  wayland.windowManager.sway.config.startup = [
    {
      command = "systemctl --user restart kanshi";
      always = true;
    }
    { command = "systemctl --user start wlsunset"; }
    { command = "autotiling"; }
    {
      command = "tmux start-server";
      always = true;
    }
  ];
}
