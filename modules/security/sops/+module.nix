{ lib, ... }:
{
  options.modules.security.sops.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
    description = "Enable sops";
  };
}
