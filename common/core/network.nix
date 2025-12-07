{
  desktop,
  ...
}:
{
  persistSystem.directories = [ "/etc/NetworkManager/system-connections" ];
  programs.nm-applet = {
    enable = desktop != null;
    indicator = true;
  };
  services.resolved = {
    enable = true;
    dnsovertls = "opportunistic";
    domains = [ "~." ];
    fallbackDns = [ ];
    extraConfig = ''
      MulticastDNS=yes
    '';
  };
  networking = {
    nameservers = [
      "1.1.1.1#one.one.one.one"
      "1.0.0.1#one.one.one.one"
    ];
    firewall = {
      allowedUDPPorts = [ 5353 ];
      # checkReversePath = false;
    };
    useDHCP = false;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      connectionConfig."connection.mdns" = 2;
    };
  };
}
