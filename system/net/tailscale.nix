{
  lib,
  config,
  ...
}: {
  options = {
    net.tailscale = {
      enable =
        lib.mkEnableOption "Enable tailscale";
    };
  };

  config = lib.mkIf config.net.tailscale.enable {
    networking.firewall = {
      trustedInterfaces = ["tailscale0"];
      # required to connect to Tailscale exit nodes
      allowedUDPPorts = [config.services.tailscale.port];
      checkReversePath = "loose";
    };

    # inter-machine VPN
    services.tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = lib.mkDefault "client";
    };
    environment.persistence = {
      "/persist".directories = ["/var/lib/tailscale"];
    };
  };
}
