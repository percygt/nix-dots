{
  config,
  lib,
  libx,
  ...
}:
{
  options.modules.core.firmware = {
    enable = libx.enableDefault "firmware";
  };

  config = lib.mkIf config.modules.core.firmware.enable { services.fwupd.enable = true; };
}
