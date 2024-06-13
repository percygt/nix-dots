{
  lib,
  config,
  username,
  ...
}: {
  options = {
    infosec.common.enable =
      lib.mkEnableOption "Enable common";
  };

  config = lib.mkIf config.infosec.common.enable {
    home-manager.users.${username} = {pkgs, ...}: {
      home.packages = with pkgs; [
        age
        sops
        git-crypt
        veracrypt
        xkcdpass
        pika-backup
      ];
    };
  };
}
