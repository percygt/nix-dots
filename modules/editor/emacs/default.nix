{
  lib,
  config,
  isGeneric,
  ...
}:
if !isGeneric
then {
  imports = [./system.nix];
  options = {
    editor = {
      emacs.system.enable = lib.mkEnableOption "Enable emacs systemwide";
      emacs.persist.enable = lib.mkOption {
        description = "Enable emacs persist";
        default = config.core.ephemeral.enable;
        type = lib.types.bool;
      };
    };
  };
}
else {
  imports = [./home.nix];
}
