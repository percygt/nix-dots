{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.modules.cli.bat.enable = lib.mkEnableOption "Enables bat";
  config = lib.mkIf config.modules.cli.bat.enable {
    programs = {
      bat = {
        enable = true;
        extraPackages = with pkgs.bat-extras; [
          batdiff
          batman
          batpipe
          prettybat
          batgrep
          batwatch
        ];
        config.theme = "Visual Studio Dark+";
      };
    };
  };
}
