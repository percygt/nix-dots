{
  config,
  lib,
  ...
}: {
  options.core.graphics = {
    enable = lib.mkOption {
      description = "Enable graphics";
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.core.graphics.enable {
    hardware.opengl = {
      enable = true;
      driSupport32Bit = true;
    };
  };
}
