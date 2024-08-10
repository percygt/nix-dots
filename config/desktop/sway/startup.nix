{
  wayland.windowManager.sway.config.startup = [
    {
      command = "systemctl --user start kanshi";
      always = true;
    }
    { command = "systemctl --user start wlsunset.service"; }
    { command = "autotiling"; }
    { command = "foot --server"; }
    { command = "tmux start-server"; }
  ];
}
