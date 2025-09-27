{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.modules.core.wifi.enable {
    persistSystem.directories = [
      "/var/lib/iwd"
    ];
    networking = {
      wireless.iwd.settings.Settings.AutoConnect = true;
      networkmanager = {
        wifi.powersave = false;
        wifi.backend = "iwd";
      };
    };
  };
}
