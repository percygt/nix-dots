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

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      { sops.secrets."wireless.env".neededForUsers = true; }
      (lib.mkIf wpa {
        users.groups.network = { };
        users.users.${g.username}.extraGroups = [ "network" ];
        services.avahi.enable = lib.mkForce false;
        systemd.services.wpa_supplicant = {
          preStart = lib.mkIf wpa "touch /etc/wpa_supplicant.conf";
          serviceConfig.TimeoutSec = "10";
        };
        networking = {
          networkmanager.enable = lib.mkForce false;
          wireless = {
            enable = true;
            fallbackToWPA2 = false;
            # secretsFile = config.sops.secrets."wireless.env".path;
            # networks = {
            #   "ext:home_ssid" = {
            #     pskRaw = "ext:home_psk";
            #   };
            # };
            environmentFile = config.sops.secrets."wireless.env".path;
            networks = {
              "@home_ssid@" = {
                psk = "@home_psk@";
              };
            };
            # Imperative
            allowAuxiliaryImperativeNetworks = true;
            userControlled = {
              enable = true;
              group = "network";
            };
            extraConfig = ''
              update_config=1
            '';
          };
        };
      })
      (lib.mkIf (!wpa) {
        systemd = {
          services.NetworkManager-wait-online.wantedBy = lib.mkForce [ ]; # Normally ["network-online.target"]
          targets.network-online.wantedBy = lib.mkForce [ ]; # Normally ["multi-user.target"]
        };
        environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
          "/persist/system" = {
            directories = [ "/etc/NetworkManager/system-connections" ];
          };
        };
        networking = {
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
        };
      })
    ]
  );
}
