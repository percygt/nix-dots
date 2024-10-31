{ lib, ... }:
{
  options.modules.cli.enable = lib.mkEnableOption "Enable cli";
}
