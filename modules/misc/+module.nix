{ lib, ... }:
{
  options.modules.misc = {
    uad.enable = lib.mkEnableOption "Enable universal-android-debloater";
    rrnoise.enable = lib.mkEnableOption "Enable rrnoise";
    ollama.enable = lib.mkEnableOption "Enable ollama";
  };
}
