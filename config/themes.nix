rec {
  gtkPackage =
    {
      pkgs,
      border ? "081028",
      bg ? "00051a",
      bg-dark ? "030205",
    }:
    pkgs.colloid-gtk-theme.overrideAttrs (_: {
      src = pkgs.fetchFromGitHub {
        owner = "vinceliuice";
        repo = "Colloid-gtk-theme";
        rev = "c572621db69ec4f9a023d883d1b82a4d559ffab5";
        hash = "sha256-+YzZ+RqqIOSj7rxavBdcROQ0fyeG5I1c54vapJjwcbg=";
      };

      installPhase =
        # bash
        ''
          runHook preInstall
          # override colors
          # sed -i "s\window-radius: 12px\window-radius: 5px\g" ./src/sass/_variables.scss
          sed -i "s/\$grey-900: #[0-9a-fA-F]\{6\};/\$grey-900: #${bg-dark};/g" ./src/sass/_color-palette-nord.scss
          sed -i "s/\$grey-600: #[0-9a-fA-F]\{6\};/\$grey-600: #${border};/g" ./src/sass/_color-palette-nord.scss
          sed -i "s/\$grey-650: #[0-9a-fA-F]\{6\};/\$grey-650: #${bg};/g" ./src/sass/_color-palette-nord.scss
          sed -i "s/\$grey-700: #[0-9a-fA-F]\{6\};/\$grey-700: #${border};/g" ./src/sass/_color-palette-nord.scss
          sed -i "s/\$grey-750: #[0-9a-fA-F]\{6\};/\$grey-750: #${bg-dark};/g" ./src/sass/_color-palette-nord.scss
          name= HOME="$TMPDIR" ./install.sh \
            --color dark \
            --tweaks rimless nord \
            --dest $out/share/themes
          jdupes --quiet --link-soft --recurse $out/share
          runHook postInstall
        '';
    });

  cursorTheme = {
    name = "phinger-cursors-light";
    package = pkgs: pkgs.phinger-cursors;
    x-scaling = 1.0;
    size = 32;
  };

  iconTheme = {
    name = "Papirus-Dark";
    package = pkgs: pkgs.catppuccin-papirus-folders;
  };

  gtkTheme = {
    name = "Colloid-Dark-Catppuccin";
    package = pkgs: pkgs.colloid-gtk-theme-catppuccin;
  };

  gnomeShellTheme = {
    name = "Colloid-Dark-Catppuccin";
    # name = "Colloid-Dark-Nord";
    # package = gtkPackage;
    package = pkgs: pkgs.colloid-gtk-theme-catppuccin;
  };
}
