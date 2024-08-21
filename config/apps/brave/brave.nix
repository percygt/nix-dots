{ pkgs, ... }:
let
  pinned-brave =
    (import (builtins.fetchTarball {
      name = "nixos-unstable-2024-08-01";
      url = "https://github.com/nixos/nixpkgs/archive/dc696e8084dbd13b915357ff51920253927cfc3c.tar.gz";
      sha256 = "0hfx2yr7nmppqxry65gsz35lcycw4xn1sala4gid57xxjfgw7m0r";
    }) { inherit (pkgs) system; }).brave;
in
{
  programs.chromium = {
    enable = true;
    package = pinned-brave;
    # extensions = [
    #   { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
    #   { id = "ocabkmapohekeifbkoelpmppmfbcibna"; } # xoom redirector
    #   { id = "kbfnbcaeplbcioakkpcpgfkobkghlhen"; } # grammarly
    #   { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
    # ];
    commandLineArgs = [
      "--ozone-platform=wayland"
      "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer,WaylandWindowDecorations"
      "--ozone-platform-hint=auto"
    ];
  };
}
