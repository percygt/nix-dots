{
  lib,
  config,
  username,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.modules.networking.tailscale.enable {
    networking.firewall = {
      trustedInterfaces = [ "tailscale0" ];
      # required to connect to Tailscale exit nodes
      allowedUDPPorts = [ config.services.tailscale.port ];
      checkReversePath = "loose";
    };
    users.users.${username}.packages = [ pkgs.tailscale ];
    # inter-machine VPN
    services.tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = lib.mkDefault "client";
    };
    persistSystem.directories = [ "/var/lib/tailscale" ];
  };
}
