{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.infosec.common.home.enable = lib.mkEnableOption "Enable common";
  config = lib.mkIf config.infosec.common.home.enable {
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
