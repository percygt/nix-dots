{
  lib,
  config,
  pkgs,
  ...
}:
let
  c = config.modules.themes.colors;
in
{
  options.modules.themes = {

    assets = {
      wallpaper = lib.mkOption {
        description = "Current wallpaper";
        type =
          with lib.types;
          oneOf [
            attrs
            path
            package
          ];
        default = pkgs.fetchurl {
          url = "https://images.unsplash.com/photo-1520264914976-a1ddb24d2114?ixlib=rb-4.0.3&q=85&fm=jpg&crop=entropy&cs=srgb&dl=michael-aleo-FDhds8oz8bA-unsplash.jpg";
          sha256 = "1dwy2619vmgca430m0vsq50289bwqi5nc5m0c02bri5phdmfxj6i";
        };
      };
      nix-logo = lib.mkOption {
        description = "Nix logo";
        type =
          with lib.types;
          oneOf [
            attrs
            path
            package
          ];
        default = pkgs.fetchurl {
          url = "https://codeberg.org/lunik1/nixos-logo-gruvbox-wallpaper/raw/branch/master/png/gruvbox-light-rainbow-square.png";
          sha256 = "1b7n1kskxzbk1w81pi78brwyjwkavyqs4hqa579xri8k3rx2r0fw";
        };
      };
    };
    colorscheme = lib.mkOption {
      description = "Current colorscheme";
      type = with lib.types; either attrs path;
      default = import ./.base24-syft-tokyo.nix;
    };
    colors = lib.mkOption {
      description = "Base24 colors";
      type = lib.types.attrs;
      default = if builtins.hasAttr "scheme" config then config.scheme else { };
    };
    opacity = lib.mkOption {
      description = "Background opacity";
      type = lib.types.float;
      default = 0.7;
    };
    cursorTheme = {
      name = lib.mkOption {
        description = "Cursor theme name";
        type = lib.types.str;
        default = "phinger-cursors-light";
      };
      package = lib.mkOption {
        description = "Cursor theme package";
        type = lib.types.package;
        default = pkgs.phinger-cursors;
      };
      size = lib.mkOption {
        description = "Cursor size";
        type = lib.types.int;
        default = 32;
      };
    };

    iconTheme = {
      name = lib.mkOption {
        description = "Icon theme name";
        type = lib.types.str;
        default = "Papirus-Dark";
      };
      package = lib.mkOption {
        description = "Icon theme package";
        type = lib.types.package;
        default = pkgs.papirus-icon-theme;
      };
    };

    qtTheme = {
      name = lib.mkOption {
        description = "Qt theme name";
        type = lib.types.str;
        default = "kvantum";
      };
      package = lib.mkOption {
        description = "QT theme package";
        type = lib.types.package;
        default = pkgs.colloid-kvantum.override {
          border = c.base04;
          bg = c.base00;
          bg-alt = c.base01;
          bg-accent = c.base02;
          black = c.base11;
        };
      };
    };

    gtkTheme = {
      name = lib.mkOption {
        description = "GTK theme name";
        type = lib.types.str;
        default = "Colloid-Dark-Catppuccin";
      };
      package = lib.mkOption {
        description = "GTK theme package";
        type = lib.types.package;
        default = pkgs.colloid-gtk-theme-catppuccin.override {
          border = c.base04;
          bg = c.base00;
          bg-alt = c.base01;
          bg-accent = c.base02;
          black = c.base11;
        };
      };
    };

    gnomeShellTheme = {
      name = lib.mkOption {
        description = "GnomeShell theme name";
        type = lib.types.str;
        default = config.modules.themes.gtkTheme.name;
      };
      package = lib.mkOption {
        description = "GnomeShell theme package";
        type = lib.types.package;
        default = config.modules.themes.gtkTheme.package;
      };
    };
    vividTheme = lib.mkOption {
      description = "Vivid theme name";
      type = lib.types.str;
      default = "custom-vivid";
    };
  };
}
