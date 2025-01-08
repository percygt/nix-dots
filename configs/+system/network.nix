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
    programs.nm-applet = {
      enable = true;
      indicator = true;
    };
    modules.core.persist.systemData.directories = [
      "/etc/NetworkManager/system-connections"
    ];
    networking = {
      wireless.iwd.settings.Settings.AutoConnect = true;
      networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };
    };
  })
]
