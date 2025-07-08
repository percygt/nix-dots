{ lib, config, ... }:
{
  config = lib.mkIf config.modules.virtualisation.waydroid.enable {
    virtualisation.waydroid.enable = true;
    modules.fileSystem.persist.systemData.directories = [ "/var/lib/waydroid" ];
  };
}
