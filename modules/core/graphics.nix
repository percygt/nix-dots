{
  config,
  lib,
  libx,
  ...
}:
{
  options.modules.core.graphics = {
    enable = libx.enableDefault "graphics";
  };

  config = lib.mkIf config.modules.core.graphics.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
