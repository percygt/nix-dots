{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.modules.udisk2.enable {
    services.udisks2 = {
      enable = true;
      mountOnMedia = true;
    };
  };
}
