{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ ./module.nix ];
  config = lib.mkIf config.modules.security.common.enable {
    home.packages = with pkgs; [
      git-crypt
      veracrypt
      xkcdpass
    ];
  };
}
