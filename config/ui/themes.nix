{
  pkgs,
  lib,
  config,
  ...
}:
{
  modules.theme = lib.mkIf config.modules.theme.enable {
    assets = {
      wallpaper = pkgs.fetchurl {
        url = "https://images.unsplash.com/photo-1520264914976-a1ddb24d2114?ixlib=rb-4.0.3&q=85&fm=jpg&crop=entropy&cs=srgb&dl=michael-aleo-FDhds8oz8bA-unsplash.jpg";
        sha256 = "1dwy2619vmgca430m0vsq50289bwqi5nc5m0c02bri5phdmfxj6i";
      };
      nix-logo = pkgs.fetchurl {
        url = "https://codeberg.org/lunik1/nixos-logo-gruvbox-wallpaper/raw/branch/master/png/gruvbox-light-rainbow-square.png";
        sha256 = "1b7n1kskxzbk1w81pi78brwyjwkavyqs4hqa579xri8k3rx2r0fw";
      };
    };
    colorscheme = import ./+assets/base24-syft-tokyo.nix;
    opacity = 0.7;
    cursorTheme = {
      name = "phinger-cursors-light";
      package = pkgs.phinger-cursors;
      size = 32;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    qtTheme = {
      name = "kvantum";
      package = pkgs.colloid-kvantum;
    };

    gtkTheme = {
      name = "Colloid-Dark-Compact-Catppuccin";
      package = pkgs.colloid-gtk-theme-catppuccin;
    };

    gnomeShellTheme = {
      name = "Colloid-Dark-Compact-Catppuccin";
      package = pkgs.colloid-gtk-theme-catppuccin;
    };
  };
}
