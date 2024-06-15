{
  lib,
  config,
  username,
  isGeneric,
  ...
}:
if (! isGeneric)
then {
  imports = [./system.nix];
  options = {
    dev.system.enable = lib.mkEnableOption "Enable devtools";
    dev.persist.enable = lib.mkOption {
      description = "Enable devtools persist";
      default = config.core.ephemeral.enable;
      type = lib.types.bool;
    };
  };
}
else {imports = [./home.nix];}
