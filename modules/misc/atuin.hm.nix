{ config, lib, ... }:
{
  config = lib.mkIf config.modules.misc.atuin.enable {
    programs.atuin = {
      enable = true;
      flags = [ "--disable-up-arrow" ];
    };
  };
}
