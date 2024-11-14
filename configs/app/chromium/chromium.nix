{
  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--password-store=basic"
      "--enable-features=WebRTCPipeWireCapturer"
      "--wm-window-animations-disabled"
      "--animation-duration-scale=0"
    ];
  };
}
