{ lib, config, ... }:
{
  config = lib.mkIf config.modules.driver.inputremapper.enable {
    services.input-remapper.enable = true;
  };
}
