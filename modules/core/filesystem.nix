{ config, lib, ... }:
{
  options.modules.core.filesystem = {
    enable = lib.mkOption {
      description = "Enable filesystem services";
      default = true;
      type = lib.types.bool;
    };
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
