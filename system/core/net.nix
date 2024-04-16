{
  lib,
  config,
  ...
}: let
  wpa = config.core.net.wpa.enable;
in {
  options = {
    core.net = {
      enable =
        lib.mkEnableOption "Enable net";
      wpa.enable = lib.mkEnableOption "Enable wpa";
    };
  };

  config = lib.mkIf config.core.net.enable {
    networking =
      if (!wpa)
      then {
        wireless.enable = lib.mkForce false;
        networkmanager = {
          enable = true;
          wifi = {
            backend = "iwd";
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

    sops.secrets."wireless.env" = lib.mkIf wpa {
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
