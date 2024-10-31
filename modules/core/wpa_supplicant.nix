{
  lib,
  config,
  ...
}:
let
  g = config._general;
  cfg = config.modules.core.wpa_supplicant;
in
{
  options.modules.core.wpa_supplicant.enable = lib.mkEnableOption "Enable wpa";

  config = lib.mkIf cfg.enable {
    users.groups.network = { };
    users.users.${g.username}.extraGroups = [ "network" ];
    services.avahi.enable = lib.mkForce false;
    systemd.services.wpa_supplicant = {
      preStart = "touch /etc/wpa_supplicant.conf";
      serviceConfig.TimeoutSec = "10";
    };
    networking = {
      networkmanager.enable = lib.mkForce false;
      wireless = {
        enable = true;
        secretsFile = config.sops.secrets."wireless.env".path;
        networks = {
          "${g.network.wifi}" = {
            hidden = true;
            psk = "ext:home_psk";
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
  };
}
