{
  inputs,
  homeDirectory ? "~",
  desktop ? "null",
}: rec {
  colors = (import ./colors.nix) // inputs.nix-colors.lib;
  fonts = import ./fonts.nix {inherit desktop;};
  wallpaper = "${homeDirectory}/.local/share/backgrounds/nice-mountain.jpg";
  sway = import ./sway.nix {inherit (inputs.nixpkgs) lib;};
  toRasi = import ./toRasi.nix {inherit (inputs.nixpkgs) lib;};
  mkFileList = dir: builtins.attrNames (builtins.readDir dir);
  cursorTheme = {
    name = "phinger-cursors-light";
    package = pkgs: pkgs.phinger-cursors;
    x-scaling = 1.0;
    size = 32;
  };
  iconTheme = {
    name = "Papirus-Dark";
    package = pkgs:
      pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "lavender";
      };
  };
  gtkTheme = {
    name = "Colloid-Dark-Nord";
    package = pkgs:
      pkgs.colloid-gtk-theme.overrideAttrs (oldAttrs: {
        src = pkgs.fetchFromGitHub {
          owner = "vinceliuice";
          repo = "Colloid-gtk-theme";
          rev = "c572621db69ec4f9a023d883d1b82a4d559ffab5";
          hash = "sha256-+YzZ+RqqIOSj7rxavBdcROQ0fyeG5I1c54vapJjwcbg=";
        };

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
}
