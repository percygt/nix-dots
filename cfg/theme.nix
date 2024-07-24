{ pkgs, ... }:
{
  setTheme = {
    colorscheme = import ./myColorScheme.nix;
    opacity = 0.8;
    cursorTheme = {
      name = "phinger-cursors-light";
      package = pkgs.phinger-cursors;
      size = 32;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders;
    };

    gtkTheme = {
      name = "Colloid-Dark-Catppuccin";
      package = pkgs.colloid-gtk-theme-catppuccin;
    };

    gnomeShellTheme = {
      name = "Colloid-Dark-Catppuccin";
      package = pkgs.colloid-gtk-theme-catppuccin;
      # name = "Colloid-Dark-Nord";
      # package = gtkPackage;
    };
  };
}
