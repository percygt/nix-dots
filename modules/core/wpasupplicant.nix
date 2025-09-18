{
  lib,
  config,
  username,
  ...
}:
let
  g = config._global;
  cfg = config.modules.core.wpasupplicant;
in
{
  config = lib.mkIf cfg.enable {
    sops.secrets."wireless.env".neededForUsers = true;
    users.groups.network = { };
    users.users.${username}.extraGroups = [ "network" ];
    services.avahi.enable = lib.mkForce false;
    systemd.services.wpasupplicant = {
      preStart = "touch /etc/wpa_supplicant.conf";
      serviceConfig.TimeoutSec = "10";
    };
    networking = {
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
