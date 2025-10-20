{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "noto-fonts-tagalog-sans";
  version = "v3.0";

  src = fetchFromGitHub {
    owner = "ctrlcctrlv";
    repo = "Noto-Sans-Tagalog";
    rev = "dc968c7264e024dd3f59269fbc99e26b653a098e";
    hash = "sha256-ux1Qhapr/HDZK2+f3Ax5l6TbPD+/lL9WFSBcpqupvJ8=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 dist/*.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "Noto Serif Tagalog is a variable font for the baybayin script, a pre-Hispanic Philippine script used primarily in Luzon, Philippines.";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
