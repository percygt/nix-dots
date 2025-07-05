{
  config,
  lib,
  ...
}:
let
  g = config._base;
in
{
  config = lib.mkIf config.modules.btrfs.enable {
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
