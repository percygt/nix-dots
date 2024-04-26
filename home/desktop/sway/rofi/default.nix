{
  config,
  pkgs,
  libx,
  ...
}: let
  inherit (libx) fonts colors;
in {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;

    inherit (import ./theme.nix {inherit config fonts colors;}) theme;
    terminal = "${pkgs.foot}/bin/foot";
    extraConfig = {
      modi = "drun";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "APPS";
    };
  };
  home.packages = [pkgs.bemoji];
}
