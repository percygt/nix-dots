{ lib, ... }:
{
  options.modules.misc = {
    uad.enable = lib.mkEnableOption "Enable universal-android-debloater";
    ollama.enable = lib.mkEnableOption "Enable ollama";
    extraClis.enable = lib.mkEnableOption "Enable extraClis";
    ncmpcpp.enable = lib.mkEnableOption "Enable ncmpcpp";
    yazi.enable = lib.mkEnableOption "Enable yazi";
    atuin.enable = lib.mkEnableOption "Enable atuin";
    aria.enable = lib.mkEnableOption "Enable aria";
  };
}
