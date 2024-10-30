{
  config,
  lib,
  ...
}:
{
  options.modules.core.firmware.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
    description = "Enable firmware";
  };

  config = lib.mkIf config.modules.core.firmware.enable { services.fwupd.enable = true; };
}
