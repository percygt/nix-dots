{ lib, config, ... }:
{
  config = lib.mkIf config.modules.virtualisation.waydroid.enable {
    virtualisation.waydroid.enable = true;
  };
}
