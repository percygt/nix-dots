{ lib, ... }:
{
  options.modules.security.keepass.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
    description = "Enable keepass";
  };

}
