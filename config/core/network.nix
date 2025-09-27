{
  config,
  pkgs,
  desktop,
  ...
}:
{
  persistSystem = {
    directories = [
      "/etc/NetworkManager/system-connections"
    ];
  };
  programs = {
    nm-applet = {
      enable = desktop != null;
      indicator = true;
    };
  };
  services = {
    # DNS resolver
    resolved = {
      enable = true;
      dnsovertls = "opportunistic";
      domains = [ "~." ];
      fallbackDns = config.networking.nameservers;
      extraConfig = ''
        MulticastDNS=yes
      '';
    };
  };
  services.avahi.enable = false;
  networking = {
    nameservers = [
      "1.1.1.1#one.one.one.one"
      "1.0.0.1#one.one.one.one"
    ];
    firewall.allowedUDPPorts = [
      5353
    ];
    useDHCP = false;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      connectionConfig."connection.mdns" = 2;
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };
  };
}
