{
  wayland.windowManager.sway.config.startup = [
    { command = "swaymsg bar bar-1 mode dock"; }
    {
      command = "systemctl --user restart kanshi";
      always = true;
    }
    { command = "systemctl --user start wlsunset.service"; }
    { command = "autotiling"; }
    { command = "foot --server"; }
    {
      command = "tmux start-server";
      always = true;
    }
  ];
}
