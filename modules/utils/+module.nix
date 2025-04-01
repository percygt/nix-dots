{ lib, ... }:
{
  options.modules.utils = {
    uad.enable = lib.mkEnableOption "Enable universal-android-debloater";
    ollama.enable = lib.mkEnableOption "Enable ollama";
    xremap.enable = lib.mkEnableOption "Enable xremap";
    keyd.enable = lib.mkEnableOption "Enable keyd";
  };
}
