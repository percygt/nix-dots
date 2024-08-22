{ pkgs, ... }:
# let
#   pinned-brave =
#     (import (builtins.fetchTarball {
#       name = "nixos-unstable-2024-08-01";
#       url = "https://github.com/nixos/nixpkgs/archive/dd6d24ac8d12a5cf0349efea3bea15fa1bdd14f3.tar.gz";
#       sha256 = "02aqx6v1ngn0s58vr8myd5cb8max9vaxkqpw8cv7rwj45r9bwgid";
#     }) { inherit (pkgs) system; }).brave;
# in
{
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "ocabkmapohekeifbkoelpmppmfbcibna"; } # xoom redirector
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
    ];
    commandLineArgs = [
      "--ozone-platform=wayland"
      "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer,WaylandWindowDecorations,MiddleClickAutoscroll,WebUIDarkMode,VaapiVideoDecodeLinuxGL"
      "--use-gl=angle"
      "--use-angle=gl"
      # "--disable-features=WebRtcAllowInputVolumeAdjustment"
    ];
  };
}
