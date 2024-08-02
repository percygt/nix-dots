{
  config,
  lib,
  libx,
  ...
}:
{
  options.modules.core.filesystem = {
    enable = libx.enableDefault "filesystem";
  };

  config = lib.mkIf config.modules.core.filesystem.enable {
    services = {
      btrfs.autoScrub = {
        enable = true;
        interval = "weekly";
      };
      udisks2 = {
        enable = true;
        mountOnMedia = true;
      };
      hardware.bolt.enable = true;
      fstrim.enable = true;
      gvfs.enable = true;
    };
  };
}
