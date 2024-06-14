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
      neovim.system.enable = lib.mkEnableOption "Enable neovim systemwide";
      neovim.persist.enable = lib.mkOption {
        description = "Enable neovim persist";
        default = config.core.ephemeral.enable;
        type = lib.types.bool;
      };
    };
  };
}
else {
  imports = [./home.nix];
}
