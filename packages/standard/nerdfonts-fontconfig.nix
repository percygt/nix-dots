{
  stdenv,
  fetchurl,
  nerd-fonts,
  lib,
  ...
}:
stdenv.mkDerivation rec {
  version = builtins.elemAt (lib.strings.splitString "/" nerd-fonts.symbols-only.meta.changelog) 6;
  pname = "nerdfonts-fontconfig";
  src = fetchurl {
    url = "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/${version}/10-nerd-font-symbols.conf";
    hash = "sha256-g7cLf3BqztHc7V0K7Gfgtu96f+6fyzcTVxfrdoeGjNM=";
  };
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    runHook preInstall

    fontconfigdir="$out/etc/fonts/conf.d"
    install -d "$fontconfigdir"
    install "$src" "$fontconfigdir/10-nerd-font-symbols.conf"

    runHook postInstall
  '';
  enableParallelBuilding = true;
}
