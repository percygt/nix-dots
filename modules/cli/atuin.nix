{ lib, config, ... }:
{
  config = lib.mkIf config.modules.cli.enable {
    programs.atuin = {
      enable = true;
      flags = [ "--disable-up-arrow" ];
    };
  };
}
