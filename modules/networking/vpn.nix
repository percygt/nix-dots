{
  config,
  lib,
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
      enable = mkEnableOption "Enable Wireguard Vpn";
    };
  };

  config = mkIf cfg.enable {
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
  };
}
