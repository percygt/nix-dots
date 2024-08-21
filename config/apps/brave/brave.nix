{ pkgs, ... }:
{
  programs.chromium = {
    package = pkgs.stash.brave;
    enable = true;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "ocabkmapohekeifbkoelpmppmfbcibna"; } # xoom redirector
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # dark reader
      { id = "kbfnbcaeplbcioakkpcpgfkobkghlhen"; } # grammarly
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
    ];
    commandLineArgs = [
      "--ozone-platform=wayland"
      "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer,WaylandWindowDecorations"
      "--ozone-platform-hint=auto"
    ];
  };
}
