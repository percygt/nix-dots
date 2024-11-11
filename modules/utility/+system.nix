{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.modules.utility.uad.enable {
    environment.systemPackages = with pkgs; [ universal-android-debloater ];
  };
}
