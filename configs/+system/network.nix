{
  lib,
  config,
  ...
}:
let
  wpa = config.modules.core.wpasupplicant.enable;
in
lib.mkIf (!wpa) {
  programs.nm-applet = {
    enable = true;
    indicator = true;
  };
  modules.core.persist.systemData.directories = [
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
    };
  };
}
