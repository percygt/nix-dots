{ lib, config, ... }:
let
  g = config._base;
in
{
  config = lib.mkIf config.modules.virtualisation.vmvariant.enable {
    virtualisation.vmVariant = {
      # following configuration is added only when building VM with build-vm
      sharedDirectories = {
        my-data = {
          source = "${g.windowsDirectory}/sharedData";
          target = "/mnt/sharedData";
        };
      };
      virtualisation = {
        memorySize = 8192; # Use 2048MiB memory.
        cores = 4;
      };
    };
  };
}
