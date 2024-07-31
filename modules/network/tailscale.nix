{
  lib,
  config,
  pkgs,
  username,
  ...
}:
{
  options.modules.network.tailscale.enable = lib.mkEnableOption "Enable tailscale";

  config = lib.mkIf config.modules.network.tailscale.enable {
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
    environment.persistence = {
      "/persist/system".directories = [ "/var/lib/tailscale" ];
    };
  };
}
