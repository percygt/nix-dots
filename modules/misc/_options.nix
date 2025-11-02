{ lib, ... }:
{
  options.modules.misc = {
    uad.enable = lib.mkEnableOption "Enable universal-android-debloater";
    ollama.enable = lib.mkEnableOption "Enable ollama";
    fzf.enable = lib.mkEnableOption "Enable fzf";
    eza.enable = lib.mkEnableOption "Enable eza";
    extraClis.enable = lib.mkEnableOption "Enable extraClis";
    ncmpcpp.enable = lib.mkEnableOption "Enable ncmpcpp";
    yazi.enable = lib.mkEnableOption "Enable yazi";
    atuin.enable = lib.mkEnableOption "Enable atuin";
    aria.enable = lib.mkEnableOption "Enable aria";
  };
}
