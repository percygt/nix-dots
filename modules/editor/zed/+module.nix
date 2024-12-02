{ lib, ... }:
{
  options.modules.editor.zed.enable = lib.mkEnableOption "Enable zed systemwide";
}
