{
  config,
  ...
}:
let
  g = config._base;
in
{
  services = {
    btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "${g.dataDirectory}" ];
      interval = "weekly";
    };
    udisks2 = {
      enable = true;
      mountOnMedia = true;
    };
    hardware.bolt.enable = true;
    fstrim.enable = true;
  };
}
