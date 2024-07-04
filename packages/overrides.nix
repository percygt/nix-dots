{
  prev,
  final,
}: let
  colors = import ../lib/libx/colors.nix;
in {
  ripgrep = prev.ripgrep.override {withPCRE2 = true;};
  borgmatic = prev.borgmatic.override {enableSystemd = false;};
  logseq = prev.logseq.overrideAttrs (oldAttrs: {
    postFixup = ''
      makeWrapper ${prev.electron_28}/bin/electron $out/bin/${oldAttrs.pname} \
        --add-flags $out/share/${oldAttrs.pname}/resources/app \
        --add-flags "--use-gl=desktop" \
        --prefix LD_LIBRARY_PATH : "${prev.lib.makeLibraryPath [prev.stdenv.cc.cc.lib]}"
    '';
  });

  catppuccin-papirus-folders = prev.catppuccin-papirus-folders.override {
    flavor = "mocha";
    accent = "lavender";
  };
  colloid-gtk-theme = prev.colloid-gtk-theme.overrideAttrs (_: {
    src = prev.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "Colloid-gtk-theme";
      rev = "c572621db69ec4f9a023d883d1b82a4d559ffab5";
      hash = "sha256-+YzZ+RqqIOSj7rxavBdcROQ0fyeG5I1c54vapJjwcbg=";
    };

    installPhase =
      /*
      bash
      */
      ''
        runHook preInstall
        # override colors
        # sed -i "s\window-radius: 12px\window-radius: 5px\g" ./src/sass/_variables.scss

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
}
