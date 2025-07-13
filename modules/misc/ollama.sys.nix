{ lib, config, ... }:
{
  config = lib.mkIf config.modules.misc.ollama.enable {
    services.ollama.enable = true;
  };
}
