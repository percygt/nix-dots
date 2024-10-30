{ lib, ... }:
{
  options.modules.security.backup.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
    description = "Enable backup";
  };
}
