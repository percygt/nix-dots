{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    infosec.backup.enable =
      lib.mkEnableOption "Enable backup";
  };

  config = lib.mkIf config.infosec.backup.enable {
    home.packages = with pkgs; [
      pika-backup
      # borgbackup
      # borgmatic
    ];
  };
}
