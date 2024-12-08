{
  programs.mpv = {
    enable = true;
    config = {
      profile = "gpu-hq";
      force-window = true;
      ytdl-format = "bestvideo+bestaudio";
      sub-auto = "all";
      osd-on-seek = "msg-bar";
      hwdec = "auto-safe";
    };
  };
  wayland.windowManager.sway.config.window.commands = [
    {
      criteria = {
        instance = "rpiplay";
      };
      command = "fullscreen enable";
    }
  ];
  xdg.mimeApps.defaultApplications =
    let
      mpv = [ "mpv.desktop" ];
    in
    {
      "video/*" = mpv;
      "application/ogg" = mpv;
      "application/x-cue" = mpv;
      "application/x-ogg" = mpv;
      "application/xspf+xml" = mpv;
      "x-content/audio-cdda" = mpv;
      "application/mxf" = mpv;
      "application/sdp" = mpv;
      "application/smil" = mpv;
      "application/streamingmedia" = mpv;
      "application/vnd.apple.mpegurl" = mpv;
      "application/vnd.ms-asf" = mpv;
      "application/vnd.rn-realmedia" = mpv;
      "application/vnd.rn-realmedia-vbr" = mpv;
      "application/x-extension-m4a" = mpv;
      "application/x-extension-mp4" = mpv;
      "application/x-matroska" = mpv;
      "application/x-mpegurl" = mpv;
      "application/x-ogm" = mpv;
      "application/x-ogm-video" = mpv;
      "application/x-shorten" = mpv;
      "application/x-smil" = mpv;
      "application/x-streamingmedia" = mpv;
    };
}
