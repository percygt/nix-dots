{
  stdenvNoCC,
  fetchzip,
  lib,
  ...
}:
stdenvNoCC.mkDerivation rec {
  pname = "cryptofont";
  version = "1.4.0";

  src = fetchzip {
    url = "https://github.com/Cryptofonts/cryptofont/archive/refs/tags/${version}.zip";
    hash = "sha256-RG2SWWH9pSDOYeLB9eb+R8cqR4iiv9YA4+98rlCKfBY=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 ${pname}-${version}/fonts/*.ttf -t $out/share/fonts/truetype
    install -Dm444 ${pname}-${version}/fonts/*.woff -t $out/share/fonts/woff

    runHook postInstall
  '';

  meta = with lib; {
    description = "Cryptocurrency icon webfont and SVG";
    license = licenses.gpl3Only;
    platforms = platforms.all;
  };
}
