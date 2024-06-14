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
    cli.system.enable = lib.mkEnableOption "Enable cli systemwide";
    cli.persist.enable = lib.mkOption {
      description = "Enable vscode persist";
      default = config.core.ephemeral.enable;
      type = lib.types.bool;
    };
  };
}
else {
  imports = [./home.nix];
}
