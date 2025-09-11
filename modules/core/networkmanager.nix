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
    services = {
      # DNS resolver
      resolved = {
        enable = true;
        dnsovertls = "opportunistic";
      };
    };
    networking = {
      wireless.iwd.settings = {
        IPv6.Enabled = true;
        Settings.AutoConnect = true;
      };
      useDHCP = false;
      nftables.enable = true;
      networkmanager = {
        dns = "systemd-resolved";
        enable = true;
        wifi.powersave = false;
        wifi.backend = "iwd";
        plugins = with pkgs; [
          # networkmanager-fortisslvpn
          # networkmanager-iodine
          # networkmanager-l2tp
          # networkmanager-openconnect
          networkmanager-openvpn
          # networkmanager-sstp
          # networkmanager-strongswan
          # networkmanager-vpnc
        ];
      };
    };
  };
}
