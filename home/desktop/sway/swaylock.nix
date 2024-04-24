{libx, ...}: {
  programs.swaylock = {
    settings = {
      image = libx.wallpaper;
      daemonize = true;
      ignore-empty-password = true;
    };
  };
}
