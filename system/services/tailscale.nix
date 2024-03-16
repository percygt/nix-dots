{config, ...}: {
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
  };
}
