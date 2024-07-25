{ lib, config, ... }:
{
  options.modules.cli.eza.enable = lib.mkEnableOption "Enables eza";
  config = lib.mkIf config.modules.cli.eza.enable {
    programs = {
      eza = {
        enable = true;
        icons = true;
      };
    };
  };
}
