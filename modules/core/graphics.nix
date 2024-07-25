{ config, lib, ... }:
{
  options.modules.core.graphics = {
    enable = lib.mkOption {
      description = "Enable graphics";
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.modules.core.graphics.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
