{
  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--ozone-platform=wayland"
      "--enable-features=WebRTCPipeWireCapturer,VaapiVideoEncoder,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE"
      "--ignore-gpu-blocklist"
      "--use-gl=angle"
      "--use-angle=vulkan"
    ];
  };
}
