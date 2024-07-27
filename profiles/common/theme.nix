{ pkgs, ... }:
{
  modules.theme = {
    assets = {
      wallpaper = {
        url = "https://images.unsplash.com/photo-1520264914976-a1ddb24d2114?ixlib=rb-4.0.3&q=85&fm=jpg&crop=entropy&cs=srgb&dl=michael-aleo-FDhds8oz8bA-unsplash.jpg";
        sha256 = "1dwy2619vmgca430m0vsq50289bwqi5nc5m0c02bri5phdmfxj6i";
      };
      nix-logo = {
        url = "https://github.com/NixOS/nixos-artwork/blob/master/logo/nix-snowflake-rainbow.svg";
        sha256 = "1maj73n7dc1nz4n92z78qhwsksldgvga6f20rv9vwrkwifb4g4zw";
      };
    };
    colorscheme = import ./colorscheme.nix;
    opacity = 0.8;
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
      name = "Colloid-Dark-Catppuccin";
      package = pkgs.colloid-gtk-theme-catppuccin;
    };

    gnomeShellTheme = {
      name = "Colloid-Dark-Catppuccin";
      package = pkgs.colloid-gtk-theme-catppuccin;
    };
  };
}
