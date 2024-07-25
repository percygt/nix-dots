{ config, lib, ... }:
{
  options.modules.core.firmware = {
    enable = lib.mkOption {
      description = "Enable firmware services";
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.modules.core.firmware.enable { services.fwupd.enable = true; };
}
