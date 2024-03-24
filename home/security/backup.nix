{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    security.backup.enable =
      lib.mkEnableOption "Enable backup";
  };

  config = lib.mkIf config.security.backup.enable {
    home.packages = with pkgs; [
      pika-backup
      borgbackup
      borgmatic
    ];
  };
}
