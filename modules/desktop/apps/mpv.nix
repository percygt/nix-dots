{
  programs.mpv = {
    enable = true;
    # catppuccin.enable = true;
    config = {
      gapless-audio = "no";
      sub-auto = "all";
      osd-on-seek = "msg-bar";
      hwdec = "auto-safe";
    };
  };
}
