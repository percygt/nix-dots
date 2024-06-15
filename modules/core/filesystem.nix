{
  config,
  lib,
  ...
}: {
  options.core.filesystem = {
    enable = lib.mkOption {
      description = "Enable filesystem services";
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.core.filesystem.enable {
    services = {
      hardware.bolt.enable = true;
      udisks2 = {
        enable = true;
        mountOnMedia = true;
      };
      fstrim.enable = true;
      gvfs.enable = true;
    };
  };
}
