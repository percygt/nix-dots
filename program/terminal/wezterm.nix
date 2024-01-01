{
  pkgs,
  lib,
  ...
}: let
  nixgl = import ../../nixgl.nix {
    inherit pkgs lib;
  };
in {
  programs.wezterm = {
    enable = true;
    package = nixgl.nixGLVulkanMesaWrap pkgs.wezterm_custom;
    colorSchemes = {
      myCoolTheme = {
        ansi = [
          "#222222"
          "#D14949"
          "#48874F"
          "#AFA75A"
          "#599797"
          "#8F6089"
          "#5C9FA8"
          "#8C8C8C"
        ];
        brights = [
          "#444444"
          "#FF6D6D"
          "#89FF95"
          "#FFF484"
          "#97DDFF"
          "#FDAAF2"
          "#85F5DA"
          "#E9E9E9"
        ];
        background = "#1B1B1B";
        cursor_bg = "#BEAF8A";
        cursor_border = "#BEAF8A";
        cursor_fg = "#1B1B1B";
        foreground = "#BEAF8A";
        selection_bg = "#444444";
        selection_fg = "#E9E9E9";
      };
    };
  };
  xdg.configFile.wezterm.source = ../../common/wezterm;
}
