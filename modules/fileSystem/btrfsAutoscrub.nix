{
  config,
  lib,
  ...
}:
let
  g = config._base;
in
{
  config = lib.mkIf config.modules.fileSystem.btrfsAutoscrub.enable {
    services = {
      btrfs.autoScrub = {
        enable = true;
        fileSystems = [ "${g.dataDirectory}" ];
        interval = "weekly";
      };
      fstrim.enable = true;
    };
  };
}
