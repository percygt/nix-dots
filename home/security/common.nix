{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    security.common.enable =
      lib.mkEnableOption "Enable common";
  };

  config = lib.mkIf config.security.common.enable {
    home.packages = with pkgs; [
      age
      sops
      git-crypt
      veracrypt
      xkcdpass
    ];
  };
}
