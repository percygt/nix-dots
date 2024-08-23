{
  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--ozone-platform=wayland"
      "--enable-features=WebRTCPipeWireCapturer,VaapiVideoDecodeLinuxGL,VaapiVideoEncoder,CanvasOopRasterization"
      "--ignore-gpu-blocklist"
      "--enable-webrtc-hw-decoding"
      "--enable-webrtc-hw-encoding"
      "--use-gl=angle"
      "--use-angle=gl"
    ];
  };
}
