{
  lib,
  config,
  pkgs,
  ...
}:
let
  g = config._general;
in
{
  config = lib.mkIf config.modules.networking.tailscale.enable {
    networking.firewall = {
      trustedInterfaces = [ "tailscale0" ];
      # required to connect to Tailscale exit nodes
      allowedUDPPorts = [ config.services.tailscale.port ];
      checkReversePath = "loose";
    };
    users.users.${g.username}.packages = [ pkgs.tailscale ];
    # inter-machine VPN
    services.tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = lib.mkDefault "client";
    };
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist/system".directories = [ "/var/lib/tailscale" ];
    };
  };
}
