{
  lib,
  config,
  ...
}: {
  options.virt.vmvariant.enable = lib.mkEnableOption "Enable vmvariant";
  config = lib.mkIf config.virt.vmvariant.enable {
    virtualisation.vmVariant = {
      # following configuration is added only when building VM with build-vm
      virtualisation = {
        memorySize = 8192; # Use 2048MiB memory.
        cores = 4;
      };
    };
  };
}
