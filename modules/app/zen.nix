{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.modules.app.zen.enable {
    modules.core.persist.userData.directories = [ ".zen" ];
    home.packages = [ pkgs.zen-browser-twilight ];
  };
}
