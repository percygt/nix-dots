{
  config,
  lib,
  ...
}: {
  options = {
    core.storage = {
      enable =
        lib.mkEnableOption "Enable storage services";
    };
  };

  config = lib.mkIf config.core.storage.enable {
    services.fstrim.enable = true;
  };
}
