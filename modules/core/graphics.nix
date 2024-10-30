{
  config,
  lib,
  ...
}:
{
  options.modules.core.graphics.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
    description = "Enable graphics";
  };

  config = lib.mkIf config.modules.core.graphics.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
