{
  lib,
  config,
  desktop,
  pkgs,
  ...
}:
let
  cfg = config.modules.core.networkmanager;
in
{
  config = lib.mkIf cfg.enable {
    programs.nm-applet = {
      enable = desktop != null;
      indicator = true;
    };
    modules.core.wpasupplicant.enable = lib.mkForce false;
    modules.fileSystem.persist.systemData.directories = [
      "/etc/NetworkManager/system-connections"
    ];
    networking = {
      wireless.iwd.settings.Settings.AutoConnect = true;
      # These options are unnecessary when managing DNS ourselves
      useDHCP = false;
      dhcpcd.enable = false;
      # Configure DNS servers manually (this example uses Cloudflare and Google DNS)
      # IPv6 DNS servers can be used here as well.
      nameservers = [
        "1.1.1.1"
        "1.0.0.1"
        "8.8.8.8"
        "8.8.4.4"
      ];
      networkmanager = {
        enable = true;
        dns = "none";
        wifi.backend = "iwd";
        plugins = with pkgs; [
          networkmanager-fortisslvpn
          networkmanager-iodine
          networkmanager-l2tp
          networkmanager-openconnect
          networkmanager-openvpn
          networkmanager-sstp
          networkmanager-strongswan
          networkmanager-vpnc
        ];
      };
    };
  };
}
