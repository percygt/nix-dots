{
  wayland.windowManager.sway.config.startup = [
    # { command = "systemctl --user start wlsunset"; }
    { command = "autotiling"; }
    {
      command = "tmux start-server";
      always = true;
    }
    # {
    #   command = "wl-paste -t text --watch clipman store --no-persist --unix --max-items=1000 1>> $HOME/.local/cache/clipman.log 2>&1";
    #   always = true;
    # }
    # {
    #   command = "shikane";
    #   always = true;
    # }
  ];
}
