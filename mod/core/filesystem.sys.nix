{
  config,
  lib,
  ...
}:
let
  g = config._base;
in
{
  config = lib.mkIf config.modules.filesystem.enable {
    services = {
      udisks2 = {
        enable = true;
        mountOnMedia = true;
      };
      btrfs.autoScrub = {
        enable = true;
        fileSystems = [ "${g.dataDirectory}" ];
        interval = "weekly";
      };
      fstrim.enable = true;
    };
  };
}
