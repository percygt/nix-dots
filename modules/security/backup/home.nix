{
  lib,
  config,
  pkgs,
  libx,
  ...
}:
{
  options.modules.security.backup.enable = libx.enableDefault "backup";
  config = lib.mkIf config.modules.security.backup.enable {
    home.packages = with pkgs; [ pika-backup ];
    sops.secrets."backup/key" = { };
    services.udiskie.settings.device_config = [
      {
        id_uuid = "129829fa-acfb-4c09-815d-b450ebaa9262";
        keyfile = config.sops.secrets."backup/key".path;
      }
    ];
  };
}
