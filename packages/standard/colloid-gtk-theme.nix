{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gnome-themes-extra,
  gtk-engine-murrine,
  jdupes,
  sassc,
  scheme ? "catppuccin",
  border ? "6e738d",
  bg ? "081028",
  bg-dark ? "00051a",
  bg-accent ? "00081e",
  bg-black ? "030205",
}:

let
  pname = "colloid-gtk-theme";
in
stdenvNoCC.mkDerivation rec {
  inherit pname;
  version = "2024-07-20";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    hash = "sha256-cWg6ghxOBbRc8nqTwjp4i4T38bFAtBJC9A7jjSEzRWA=";
  };

  nativeBuildInputs = [
    jdupes
    sassc
  ];

  buildInputs = [ gnome-themes-extra ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  postPatch = ''
    patchShebangs install.sh
  '';

  installPhase = ''
    runHook preInstall
    sed -i "s/\$grey-900: #[0-9a-fA-F]\{6\};/\$grey-900: #${bg-dark};/g" ./src/sass/_color-palette-${scheme}.scss
    sed -i "s/\$grey-600: #[0-9a-fA-F]\{6\};/\$grey-600: #${border};/g" ./src/sass/_color-palette-${scheme}.scss
    sed -i "s/\$grey-650: #[0-9a-fA-F]\{6\};/\$grey-650: #${bg-accent};/g" ./src/sass/_color-palette-${scheme}.scss
    sed -i "s/\$grey-700: #[0-9a-fA-F]\{6\};/\$grey-700: #${bg};/g" ./src/sass/_color-palette-${scheme}.scss
    sed -i "s/\$grey-750: #[0-9a-fA-F]\{6\};/\$grey-750: #${bg-black};/g" ./src/sass/_color-palette-${scheme}.scss
    # opinionated install
    name= HOME="$TMPDIR" ./install.sh \
          --color dark \
          --tweaks rimless ${scheme} \
          --dest $out/share/themes
    jdupes --quiet --link-soft --recurse $out/share
    runHook postInstall
  '';

  meta = with lib; {
    description = "Modern and clean Gtk theme";
    homepage = "https://github.com/vinceliuice/Colloid-gtk-theme";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
