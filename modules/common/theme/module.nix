{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  options.setTheme = {
    colorscheme = lib.mkOption {
      description = "Current colorscheme";
      type = with lib.types; either attrs path;
      default = "${inputs.tt-schemes}/base24/one-dark.yaml";
    };
    colors = lib.mkOption {
      description = "Current colors";
      type = lib.types.anything;
      default = config.scheme;
    };
    opacity = lib.mkOption {
      description = "Background opacity";
      type = lib.types.float;
      default = 0.8;
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
        default = pkgs.catppuccin-papirus-folders;
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
        default = pkgs.colloid-kvantum;
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
        default = pkgs.colloid-gtk-theme-catppuccin;
      };
    };

    gnomeShellTheme = {
      name = lib.mkOption {
        description = "GnomeShell theme name";
        type = lib.types.str;
        default = config.setTheme.gtkTheme.name;
      };
      package = lib.mkOption {
        description = "GnomeShell theme package";
        type = lib.types.package;
        default = config.setTheme.gtkTheme.package;
      };
    };
  };
}
