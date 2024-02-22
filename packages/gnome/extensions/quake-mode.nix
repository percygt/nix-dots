{
  lib,
  stdenv,
  glib,
  fetchFromGitHub,
}: let
  uuid = "quake-mode@repsac-by.github.com";
in
  stdenv.mkDerivation rec {
    pname = "gnome-shell-extension-quake-mode";
    version = "10";

    src = fetchFromGitHub {
      owner = "repsac-by";
      repo = "gnome-shell-extension-quake-mode";
      rev = "50d4505d109ac474ed7b82397447559ddcebd7f8";
      hash = "sha256-er71pDa13orFVerWLKVGb2jR+74AUbRWhZZAgW+xm7g=";
    };

    nativeBuildInputs = [glib];

    buildPhase = ''
      runHook preBuild
      glib-compile-schemas --strict --targetdir="quake-mode@repsac-by.github.com/schemas/" "quake-mode@repsac-by.github.com/schemas"
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/gnome-shell/extensions
      cp -r "quake-mode@repsac-by.github.com" $out/share/gnome-shell/extensions
      runHook postInstall
    '';

    passthru = {
      extensionPortalSlug = pname;
      extensionUuid = uuid;
    };

    meta = with lib; {
      description = "It's a GNOME Shell extension adds support quake-mode for any application";
      license = licenses.gpl3Plus;
      maintainers = [];
      homepage = "https://github.com/repsac-by/gnome-shell-extension-quake-mode";
    };
  }
