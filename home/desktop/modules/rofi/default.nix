{
  config,
  pkgs,
  colors,
  libx,
  ...
}: let
  inherit (libx) fonts;
  rofiTheme = (import ./theme.nix {inherit colors fonts config;}).theme;
in {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;

    theme = rofiTheme;
    terminal = "${pkgs.alacritty}/bin/wezterm";
    plugins = with pkgs; [
      rofi-calc
      rofi-emoji
    ];

    extraConfig = {
      modi = "drun,emoji,calc";
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
