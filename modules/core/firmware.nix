{
  config,
  lib,
  ...
}: {
  options = {
    core.firmware = {
      enable =
        lib.mkEnableOption "Enable firmware services";
    };
  };

  config = lib.mkIf config.core.firmware.enable {
    services.fwupd.enable = true;
  };
}
