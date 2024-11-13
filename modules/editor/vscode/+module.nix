{ lib, ... }:
{
  options.modules.editor.vscode.enable = lib.mkEnableOption "Enable vscode systemwide";
}
