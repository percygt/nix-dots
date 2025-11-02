{ lib, config, ... }:
{
  config = lib.mkIf config.modules.misc.eza.enable {
    programs.eza = {
      enable = true;
      icons = "auto";
    };
  };
}
