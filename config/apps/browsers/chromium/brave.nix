{
  programs.brave = {
    enable = true;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
    ];
    commandLineArgs = [
      "--ozone-platform=wayland"
      "--enable-features=WebRTCPipeWireCapturer,VaapiVideoEncoder,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE"
      "--ignore-gpu-blocklist"
      "--use-gl=angle"
      "--use-angle=vulkan"
      # "--disable-features=WebRtcAllowInputVolumeAdjustment"
    ];
  };
}
