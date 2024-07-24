{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater,
}:

stdenvNoCC.mkDerivation rec {
  pname = "colloid-kde";
  version = "unstable-2023-07-04";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = "0b79befdad9b442b5a8287342c4b7e47ff87d555";
    hash = "sha256-AYH9fW20/p+mq6lxR1lcCV1BQ/kgcsjHncpMvYWXnWA=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/Kvantum
    cp -a Kvantum/ColloidNord $out/share/Kvantum
    cp color-schemes/ColloidDarkNord.colors $out/share/kdeglobals
    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "A clean and concise theme for KDE Plasma desktop";
    homepage = "https://github.com/vinceliuice/Colloid-kde-theme";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
