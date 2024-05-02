{
  lib,
  config,
  username,
  ...
}: let
  wpa = config.core.net.wpa.enable;
in {
  options = {
    core.net = {
      enable =
        lib.mkEnableOption "Enable networking services";
      wpa.enable = lib.mkEnableOption "Enable wpa";
    };
  };

  config = lib.mkIf config.core.net.enable {
    users.users.${username}.extraGroups = ["networking"];
    # services = {
    #   nscd.enableNsncd = true;
    #   unbound = lib.mkIf (!wpa) {
    #     enable = true;
    #     settings = {
    #       server.qname-minimisation = true;
    #       forward-zone = [
    #         {
    #           # ProtonVPN DNS, if available
    #           name = ".";
    #           forward-addr = "10.2.0.1";
    #         }
    #         {
    #           # Cloudflare backup
    #           name = ".";
    #           forward-addr = "1.1.1.1";
    #         }
    #       ];
    #     };
    #     localControlSocketPath = "/run/unbound/unbound.ctl";
    #   };
    # };
    environment.persistence = {
      "/persist/system" = lib.mkIf (!wpa) {
        directories = [
          "/etc/NetworkManager/system-connections"
        ];
      };
    };
    networking =
      if (!wpa)
      then {
        # useDHCP = lib.mkForce false;
        wireless.iwd.settings.Settings.AutoConnect = true;
        networkmanager = {
          enable = true;
          wifi = {
            backend = "iwd";
          };
          ensureProfiles = {
            environmentFiles = [config.sops.secrets."wireless.env".path];
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
                proxy = {
                };
              };
            };
          };
        };
      }
      else {
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

    services.avahi = lib.mkIf wpa {enable = lib.mkForce false;};

    sops.secrets."wireless.env" = {
      neededForUsers = true;
    };

    users.groups.network = lib.mkIf wpa {};

    systemd = {
      services.wpa_supplicant.preStart = lib.mkIf wpa "touch /etc/wpa_supplicant.conf";
      services.NetworkManager-wait-online.wantedBy = lib.mkForce []; # Normally ["network-online.target"]
      targets.network-online.wantedBy = lib.mkForce []; # Normally ["multi-user.target"]
    };
  };
}
