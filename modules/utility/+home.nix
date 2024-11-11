{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.modules.utility.uad.enable {
    home.packages = with pkgs; [ universal-android-debloater ];
  };
}
