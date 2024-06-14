{
  lib,
  config,
  isGeneric,
  ...
}:
if (! isGeneric)
then {
  imports = [./system.nix];
  options = {
    editor = {
      vscode.system.enable = lib.mkEnableOption "Enable vscode systemwide";
      vscode.persist.enable = lib.mkOption {
        description = "Enable vscode persist";
        default = config.core.ephemeral.enable;
        type = lib.types.bool;
      };
    };
  };
}
else {
  imports = [./home.nix];
}
