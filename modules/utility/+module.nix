{ lib, ... }:
{
  options.modules.utility = {
    uad.enable = lib.mkEnableOption "Enable universal-android-debloater";
  };
}
