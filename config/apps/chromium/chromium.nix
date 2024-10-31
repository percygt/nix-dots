{
  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--password-store=basic"
      "--enable-features=WebRTCPipeWireCapturer"
    ];
  };
}
