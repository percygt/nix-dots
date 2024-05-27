{
  config,
  lib,
  ...
}: {
  options = {
    core.graphics = {
      enable =
        lib.mkEnableOption "Enable graphics";
    };
  };

  config = lib.mkIf config.core.graphics.enable {
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };
}
