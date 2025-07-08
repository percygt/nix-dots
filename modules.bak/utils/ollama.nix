{ lib, config, ... }:
{
  config = lib.mkIf config.modules.utils.ollama.enable {
    services.ollama.enable = true;
  };
}
