{ lib, ... }:
{
  options.modules.security.common.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
    description = "Enable security common";
  };
}
