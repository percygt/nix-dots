{
  lib,
  config,
  pkgs,
  username,
  ...
}: {
  options.net.tailscale.system.enable = lib.mkEnableOption "Enable tailscale";

  config = lib.mkIf config.net.tailscale.system.enable {
    networking.firewall = {
      trustedInterfaces = ["tailscale0"];
      # required to connect to Tailscale exit nodes
      allowedUDPPorts = [config.services.tailscale.port];
      checkReversePath = "loose";
    };
    users.users.${username}.packages = [pkgs.tailscale];
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
