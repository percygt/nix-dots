{
  lib,
  config,
  ...
}:
let
  wpa = config.modules.core.wpa_supplicant.enable;
in
lib.mkMerge [
  {
    sops.secrets."wireless.env".neededForUsers = true;
  }
  (lib.mkIf (!wpa) {
    systemd = {
      services.NetworkManager-wait-online.wantedBy = lib.mkForce [ ]; # Normally ["network-online.target"]
      targets.network-online.wantedBy = lib.mkForce [ ]; # Normally ["multi-user.target"]
    };
    programs.nm-applet = {
      enable = true;
      indicator = true;
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
      };
    };
  })
]
