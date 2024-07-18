{
  lib,
  stdenv,
  glib,
  fetchFromGitHub,
}:
let
  uuid = "quake-mode@repsac-by.github.com";
in
stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-quake-mode";
  version = "10";

  src = fetchFromGitHub {
    owner = "repsac-by";
    repo = "gnome-shell-extension-quake-mode";
    rev = "d1f1a3d35f81cb581617635753f621af4a3cdee8";
    hash = "sha256-eqmY3oU5+kN8vaYXv3WzjU6c9CnabsTgoGUVGsjPoXs=";
  };

  nativeBuildInputs = [ glib ];

  buildPhase = ''
    runHook preBuild
    glib-compile-schemas --strict ${uuid}/schemas
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r ${uuid}/. $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';

  passthru = {
    extensionPortalSlug = pname;
    extensionUuid = uuid;
  };

  meta = with lib; {
    description = "It's a GNOME Shell extension adds support quake-mode for any application";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    homepage = "https://github.com/repsac-by/gnome-shell-extension-quake-mode";
  };
}
