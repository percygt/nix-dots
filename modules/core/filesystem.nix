{
  config,
  lib,
  ...
}: {
  options = {
    core.filesystem = {
      enable =
        lib.mkEnableOption "Enable filesystem services";
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
