{ lib, ... }:
{
  options.modules.editor.helix.enable = lib.mkEnableOption "Enable helix";
}
