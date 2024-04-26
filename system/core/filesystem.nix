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
      udisks2.enable = true;
      fstrim.enable = true;
      gvfs.enable = true;
    };
  };
}
