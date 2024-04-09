{
  pkgs,
  config,
  ui,
  lib,
  ...
}: let
  inherit (ui) colors;
in {
  options = {
    desktop.gtk.enable =
      lib.mkEnableOption "Enables gtk";
  };
  config = lib.mkIf config.desktop.gtk.enable {
    gtk = {
      enable = true;
      theme = {
        name = "Colloid-Dark-Nord";
        package = pkgs.colloid-gtk-theme.overrideAttrs (oldAttrs: {
          installPhase = ''
            runHook preInstall
            # override colors
            sed -i "s\#0d0e11\#${colors.default.background}\g" ./src/sass/_color-palette-nord.scss
            sed -i "s\#bf616a\#${colors.bright.red}\g" ./src/sass/_color-palette-nord.scss
            sed -i "s\#a3be8c\#${colors.normal.magenta}\g" ./src/sass/_color-palette-nord.scss
            sed -i "s\#ebcb8b\#${colors.bright.yellow}\g" ./src/sass/_color-palette-nord.scss
            sed -i "s\#3a4150\#${colors.extra.azure}\g" ./src/sass/_color-palette-nord.scss
            sed -i "s\#333a47\#${colors.extra.nocturne}\g" ./src/sass/_color-palette-nord.scss
            sed -i "s\#242932\#${colors.extra.nocturne}\g" ./src/sass/_color-palette-nord.scss
            sed -i "s\#1e222a\#${colors.extra.obsidian}\g" ./src/sass/_color-palette-nord.scss
            name= HOME="$TMPDIR" ./install.sh \
              --color dark \
              --tweaks rimless nord \
              --dest $out/share/themes
            jdupes --quiet --link-soft --recurse $out/share
            runHook postInstall
          '';
        });
      };
      cursorTheme = {
        name = "phinger-cursors-light";
        package = pkgs.phinger-cursors;
        size = 32;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.catppuccin-papirus-folders.override {
          flavor = "mocha";
          accent = "lavender";
        };
      };
    };
  };
}
