{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.modules.security.extraPackages.enable {
    environment.systemPackages = with pkgs; [
      age
      sops
      git-crypt
      veracrypt
      xkcdpass
    ];
  };
}
