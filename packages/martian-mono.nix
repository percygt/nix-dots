{
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "martian-mono";
  version = "1.0.0";

  src = fetchzip {
    hash = "sha256-hC08IHWqg+x3qoEf4EL98ZbGeqdwjnMpDovEiWrWPpI=";
    stripRoot = false;
    url = "https://github.com/evilmartians/mono/releases/download/v${version}/martian-mono-1.0.0-otf.zip";
  };

  postInstall = ''
    install -Dm444 *.otf -t $out/share/fonts
  '';
}
