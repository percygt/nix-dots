{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater,
  writeText,
  border ? "#6e738d",
  bg ? "#081028",
  bg-alt ? "#00051a",
  bg-accent ? "#00081e",
  black ? "#030205",
}:

stdenvNoCC.mkDerivation rec {
  pname = "colloid-kde";
  version = "2025-07-09";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = "b768904d10ba9fcb95abfb59538eab100b1fed1e";
    hash = "sha256-CWa6HnMP042jh573/x7WxYyRScN/l+jjCasiaBODljA=";
  };

  installPhase = ''
    runHook preInstall
    sed -i s/#475061/${bg-alt}/g ./Kvantum/ColloidNord/ColloidNordDark.svg
    sed -i s/#475061/${bg-alt}/g ./Kvantum/ColloidNord/ColloidNordDark.kvconfig
    sed -i s/71,80,97/0,5,26/g ./color-schemes/ColloidDarkNord.colors

    sed -i s/#3a4150/${border}/g ./Kvantum/ColloidNord/ColloidNordDark.svg
    sed -i s/#3a4150/${border}/g ./Kvantum/ColloidNord/ColloidNordDark.kvconfig
    sed -i s/58,65,80/100,115,141/g ./color-schemes/ColloidDarkNord.colors

    sed -i s/#333a47/${bg-accent}/g ./Kvantum/ColloidNord/ColloidNordDark.svg
    sed -i s/#333a47/${bg-accent}/g ./Kvantum/ColloidNord/ColloidNordDark.kvconfig
    sed -i s/51,58,71/0,8,30/g ./color-schemes/ColloidDarkNord.colors

    sed -i s/#242932/${bg}/g ./Kvantum/ColloidNord/ColloidNordDark.svg
    sed -i s/#242932/${bg}/g ./Kvantum/ColloidNord/ColloidNordDark.kvconfig
    sed -i s/36,41,50/8,16,40/g ./color-schemes/ColloidDarkNord.colors

    sed -i s/#1e222a/${black}/g ./Kvantum/ColloidNord/ColloidNordDark.svg
    sed -i s/#1e222a/${black}/g ./Kvantum/ColloidNord/ColloidNordDark.kvconfig
    sed -i s/30,34,42/3,2,5/g ./color-schemes/ColloidDarkNord.colors

    mkdir -p $out/share/Kvantum
    cp -a Kvantum/ColloidNord $out/share/Kvantum
    cp ${writeText "kvantum.kvconfig" ''
      [General]
      theme=ColloidNordDark
    ''} $out/share/Kvantum/kvantum.kvconfig
    cp color-schemes/ColloidDarkNord.colors $out/share/kdeglobals
    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "A clean and concise theme for KDE Plasma desktop";
    homepage = "https://github.com/vinceliuice/Colloid-kde-theme";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
