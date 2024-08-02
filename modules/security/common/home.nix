{
  pkgs,
  lib,
  config,
  libx,
  ...
}:
{
  options.modules.security.common.enable = libx.enableDefault "common";

  config = lib.mkIf config.modules.security.common.enable {
    home.packages = with pkgs; [
      git-crypt
      veracrypt
      xkcdpass
    ];
  };
}
