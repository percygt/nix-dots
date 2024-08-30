{
  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--enable-features=WebRTCPipeWireCapturer"
    ];
  };
}
