{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.modules.fileSystem.udisks.enable {
    services.udisks2 = {
      enable = true;
      mountOnMedia = true;
    };
  };
}
