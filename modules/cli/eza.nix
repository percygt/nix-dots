{ lib, config, ... }:
{
  options.cli.eza.home.enable = lib.mkEnableOption "Enables eza";
  config = lib.mkIf config.cli.eza.home.enable {
    programs = {
      eza = {
        enable = true;
        icons = true;
      };
    };
  };
}
