{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.modules.app.zen.enable {
    home.packages = [ pkgs.zen-browser-twilight ];
  };
}
