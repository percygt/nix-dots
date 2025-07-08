{ lib, ... }:
{
  options.modules.networking = {
    avahi.enable = lib.mkEnableOption "Enable avahi";
    syncthing.enable = lib.mkEnableOption "Enable syncthing";
    tailscale.enable = lib.mkEnableOption "Enable tailscale";
    vpn = {
      enable = lib.mkEnableOption "Enable vpn";
      wireguard.enable = lib.mkEnableOption "Enable Wireguard Vpn";
    };
  };
}
