{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.modules.security.common.enable = lib.mkEnableOption "Enable common";
  config = lib.mkIf config.modules.security.common.enable {
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
