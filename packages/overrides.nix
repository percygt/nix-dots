{ prev, final }:
let
  colors = import ../config/colors.nix;
in
{
  ripgrep = prev.ripgrep.override { withPCRE2 = true; };
  borgmatic = prev.borgmatic.override { enableSystemd = false; };
  logseq = prev.logseq.overrideAttrs (oldAttrs: {
    postFixup = ''
      makeWrapper ${prev.electron}/bin/electron $out/bin/${oldAttrs.pname} \
        --add-flags $out/share/${oldAttrs.pname}/resources/app \
        --add-flags "--use-gl=desktop" \
        --prefix LD_LIBRARY_PATH : "${prev.lib.makeLibraryPath [ prev.stdenv.cc.cc.lib ]}"
    '';
  });
  foot = prev.foot.overrideAttrs (_: {
    src = prev.fetchFromGitea {
      domain = "codeberg.org";
      owner = "dnkl";
      repo = "foot";
      rev = "1136108c9780eae9fae252a1bca5089f19fcd57d";
      hash = "sha256-1NeBDIX4N602DI52nAwJ+mNikLimBncQl5KxEhycGxY=";
    };
  });
  nerdfonts = prev.nerdfonts.override {
    fonts = [
      "VictorMono"
      "JetBrainsMono"
      "MartianMono"
      "GeistMono"
      "Monaspace"
      "Iosevka"
      "NerdFontsSymbolsOnly"
    ];
  };
  google-fonts =
    (prev.google-fonts.overrideAttrs (oldAttrs: {
      nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ prev.perl ];
      installPhase =
        (oldAttrs.installPhase or "")
        + ''
          skip=("NotoColorEmoji")

          readarray -t fonts < <(find . -name '*.ttf' -exec basename '{}' \; | perl -pe 's/(.+?)[[.-].*/\1/g' | sort | uniq)

          for font in "''${fonts[@]}"; do
            [[ "_''${skip[*]}_" =~ _''${font}_ ]] && continue
            find . -name "''${font}*.ttf" -exec install -m 444 -Dt $dest '{}' +
          done
        '';
    })).override
      {
        # Don't install fonts in the original `installPhase`
        fonts = [ "__NO_FONT__" ];
      };
  catppuccin-papirus-folders = prev.catppuccin-papirus-folders.override {
    flavor = "mocha";
    accent = "lavender";
  };
}
