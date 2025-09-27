{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.networking.vpn;
  g = config._global;
in
{
  config = lib.mkMerge [
    (mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        protonvpn-gui
      ];
    })
    (mkIf cfg.wireguard.enable {
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
