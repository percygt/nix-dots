{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.modules.app.helium.enable {
    home.packages = [ pkgs.nur.repos.Ev357.helium ];
  };
}
