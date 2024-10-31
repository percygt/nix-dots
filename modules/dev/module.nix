{ lib, ... }:
{
  options.modules.dev.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
    description = "Enable dev";
  };
}
