{
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
}
