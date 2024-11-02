{ lib, ... }:
{
  options.modules.security.ssh.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
    description = "Enable ssh";
  };
}
