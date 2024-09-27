{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.networking.vpn;
  g = config._general;
in
{
  options = {
    modules.networking.vpn = {
      enable = mkEnableOption "Enable vpn";
      wireguard.enable = mkEnableOption "Enable Wireguard Vpn";
    };
  };

  config = lib.mkMerge [
    (mkIf cfg.enable {
      modules.core.network = {
        enable = lib.mkForce true;
        wpa.enable = lib.mkForce false;
      };
      environment.systemPackages = with pkgs; [
        protonvpn-gui
      ];
    })
    (mkIf cfg.wireguard.enable {
      modules.core.network = {
        enable = lib.mkForce true;
        wpa.enable = lib.mkForce false;
      };
      sops.secrets."wireguard/key/private".neededForUsers = true;
      networking.wg-quick.interfaces."${g.network.wireguard.name}" = {
        autostart = true;
        dns = [ g.network.wireguard.dnsIp ];
        privateKeyFile = config.sops.secrets."wireguard/key/private".path;
        address = [ g.network.wireguard.address ];
        listenPort = g.network.wireguard.port;
        peers = [
          {
            publicKey = "${g.network.wireguard.publicKey}";
            allowedIPs = [
              "0.0.0.0/0"
              "::/0"
            ];
            endpoint = "${g.network.wireguard.endpointIp}:${builtins.toString g.network.wireguard.port}";
          }
        ];
      };
    })
  ];
}
