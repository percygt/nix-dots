{
  lib,
  config,
  ...
}: {
  options.virtual.vmvariant.enable = lib.mkEnableOption "Enable vmvariant";
  config = lib.mkIf config.virtual.vmvariant.enable {
    virtualisation.vmVariant = {
      # following configuration is added only when building VM with build-vm
      virtualisation = {
        memorySize = 8192; # Use 2048MiB memory.
        cores = 4;
      };
    };
  };
}
