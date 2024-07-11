{
  stdenv,
  fetchurl,
  nerdfonts,
  ...
}:
stdenv.mkDerivation {
  inherit (nerdfonts) version;
  pname = "nerdfonts-fontconfig";
  src = fetchurl {
    url = "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/v${nerdfonts.version}/10-nerd-font-symbols.conf";
    hash = "sha256-ZgHkMcXEPYDfzjdRR7KX3ws2u01GWUj48heMHaiaznY=";
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
