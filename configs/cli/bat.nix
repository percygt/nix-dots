{ pkgs, ... }:
{
  programs = {
    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        # batdiff
        batman
        batpipe
        prettybat
        batgrep
        batwatch
      ];
      config.theme = "catppuccin";
      themes = {
        catppuccin = {
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "d2bbee4f7e7d5bac63c054e4d8eca57954b31471";
            hash = "sha256-x1yqPCWuoBSx/cI94eA+AWwhiSA42cLNUOFJl7qjhmw=";
          };
          file = "themes/Catppuccin Mocha.tmTheme";
        };
      };
    };
  };
}
