{pkgs, ...}: {
  programs.chromium = {
    package = pkgs.brave;
    enable = true;
    extensions = [
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # ublock origin
      {id = "ocabkmapohekeifbkoelpmppmfbcibna";} # xoom redirector
    ];
    commandLineArgs = [
      "--ozone-platform=wayland"
      "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer"
    ];
  };
}
