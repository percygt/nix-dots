{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    infosec.common.enable =
      lib.mkEnableOption "Enable common";
  };

  config = lib.mkIf config.infosec.common.enable {
    home.packages = with pkgs; [
      age
      sops
      git-crypt
      veracrypt
      xkcdpass
      pika-backup
    ];
  };
}
