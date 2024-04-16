{
  config,
  pkgs,
  libx,
  ...
}: let
  inherit (libx) fonts colors;
  rofiTheme = (import ./theme.nix {inherit colors fonts config;}).theme;
in {
  programs.rofi = {
    enable = true;
    # package = pkgs.rofi-wayland;

    # theme = rofiTheme;
    terminal = "${pkgs.foot}/bin/foot";
    plugins = with pkgs; [
      rofi-calc
      rofi-emoji
    ];

    extraConfig = {
      # modi = "drun,emoji";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-emoji = "   Emoji ";
      display-calc = "   Calc ";
      sidebar-mode = true;
    };
  };
}
