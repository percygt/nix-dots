{
  wayland.windowManager.sway.config.startup = [
    {
      command = "foot --server";
      always = true;
    }
    { command = "autotiling"; }
    {
      command = "tmux start-server";
      always = true;
    }
  ];
}
