{ lib, config, ... }:
{
  config = lib.mkIf config.modules.networking.avahi.enable {
    # network discovery, mDNS
    services.avahi = {
      enable = true;
      # openFirewall = true;
      reflector = true;
      nssmdns4 = true;
      nssmdns6 = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        hinfo = true;
        userServices = true;
        workstation = true;
      };
    };
    services.resolved.extraConfig = lib.mkForce ''
      MulticastDNS=false
    '';
    networking.networkmanager.connectionConfig."connection.mdns" = 1;
  };
}
