{ lib, config, ... }:
let
  g = config._base;
in
{
  config = lib.mkIf config.modules.virtualisation.vmvariant.enable {
    virtualisation.vmVariant = {
      virtualisation = {
        # following configuration is added only when building VM with build-vm
        sharedDirectories = {
          sharedData = {
            source = "${g.dataDirectory}/vms/shared";
            target = "/mnt/shared";
          };
        };
        memorySize = 8192; # Use 2048MiB memory.
        cores = 4;
      };
    };
  };
}
