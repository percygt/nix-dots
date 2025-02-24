{ config, ... }:
{
  # disable NativeMessagingHosts symlink
  home.file."${config.xdg.configHome}/chromium/NativeMessagingHosts".enable = false;
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
