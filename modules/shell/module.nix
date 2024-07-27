{ lib, ... }:
{
  options.modules.shell = {
    enable = lib.mkOption {
      description = "Enable shell packages";
      default = true;
      type = lib.types.bool;
    };
    userDefaultShell = lib.mkOption {
      description = "User default shell";
      default = "fish";
      type = lib.types.str;
    };
  };
}
