{
  lib,
  config,
  libx,
  ...
}:
let
  g = config._general;
  wpa = config.modules.core.network.wpa.enable;
  cfg = config.modules.core.network;
in
{
  options.modules.core.network = {
    enable = libx.enableDefault "network";
    wpa.enable = lib.mkOption {
      description = "Enable wpa";
      type = lib.types.bool;
      default = cfg.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.persistence = {
      "/persist/system" = lib.mkIf (!wpa) { directories = [ "/etc/NetworkManager/system-connections" ]; };
    };
    networking =
      if (!wpa) then
        {
          wireless.iwd.settings.Settings.AutoConnect = true;
          networkmanager = {
            enable = true;
            wifi.backend = "iwd";
            ensureProfiles = {
              environmentFiles = [ config.sops.secrets."wireless.env".path ];
              profiles = {
                "@home_ssid@" = {
                  connection = {
                    id = "@home_ssid@";
                    uuid = "@home_uuid@";
                    type = "wifi";
                  };
                  wifi = {
                    mode = "infrastructure";
                    ssid = "@home_ssid@";
                  };
                  wifi-security = {
                    auth-alg = "open";
                    key-mgmt = "wpa-psk";
                    psk = "@home_psk@";
                  };
                  ipv4 = {
                    method = "auto";
                  };
                  ipv6 = {
                    addr-gen-mode = "default";
                    method = "auto";
                  };
                  proxy = { };
                };
              };
            };
          };
        }
      else
        {
          networkmanager.enable = lib.mkForce false;
          wireless = {
            enable = true;
            fallbackToWPA2 = false;
            environmentFile = config.sops.secrets."wireless.env".path;
            networks = {
              "@home_ssid@" = {
                psk = "@home_psk@";
              };
            };
            # Imperative
            # allowAuxiliaryImperativeNetworks = true;
            userControlled = {
              enable = true;
              group = "network";
            };
            extraConfig = ''
              update_config=1
            '';
          };
        };

    services.avahi = lib.mkIf wpa { enable = lib.mkForce false; };

    sops.secrets."wireless.env" = {
      neededForUsers = true;
    };

    users.groups.network = lib.mkIf wpa { };
    users.users.${g.username}.extraGroups = [ "network" ];

    systemd = {
      services.wpa_supplicant = {
        preStart = lib.mkIf wpa "touch /etc/wpa_supplicant.conf";
        serviceConfig.TimeoutSec = "10";
      };
      services.NetworkManager-wait-online.wantedBy = lib.mkForce [ ]; # Normally ["network-online.target"]
      targets.network-online.wantedBy = lib.mkForce [ ]; # Normally ["multi-user.target"]
    };
  };
}
