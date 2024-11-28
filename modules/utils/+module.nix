{ lib, ... }:
{
  options.modules.utils = {
    uad.enable = lib.mkEnableOption "Enable universal-android-debloater";
  };
}
