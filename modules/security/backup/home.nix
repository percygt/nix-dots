{
  lib,
  config,
  pkgs,
  libx,
  ...
}:
let
  g = config._general;
in
{
  options.modules.security.backup.enable = libx.enableDefault "backup";
  config = lib.mkIf config.modules.security.backup.enable {
    home.packages = with pkgs; [ pika-backup ];
    sops.secrets."backup/key" = { };
    services.udiskie.settings.device_config = [
      {
        id_uuid = g.backupMount.uuid;
        keyfile = config.sops.secrets."backup/key".path;
      }
    ];
  };
}
