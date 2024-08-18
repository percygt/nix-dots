{ pkgs, ... }:
{
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
}
