{ lib, ... }:
{
  options.modules.cli.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
    description = "Enable cli";
  };
}
