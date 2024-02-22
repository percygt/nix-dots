{
  lib,
  stdenv,
  glib,
  fetchFromGitHub,
}: let
  uuid = "date-menu-formatter@marcinjakubowski.github.com";
in
  stdenv.mkDerivation rec {
    pname = "date-menu-formatter";
    version = "12";

    src = fetchFromGitHub {
      owner = "marcinjakubowski";
      repo = "date-menu-formatter";
      rev = "8ae0f2e1262aa3d286bdfd7a6de3fdcd9cbb54b4";
      hash = "sha256-ML427Lh2J6zks2tnJnMA+OxK7Ue/Jr8ZZXhuf6N6Dlg=";
    };

    nativeBuildInputs = [glib];

    buildPhase = ''
      runHook preBuild
      glib-compile-schemas --strict schemas
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/gnome-shell/extensions/${uuid}
      cp -r . $out/share/gnome-shell/extensions/${uuid}
      runHook postInstall
    '';

    passthru = {
      extensionPortalSlug = pname;
      extensionUuid = uuid;
    };

    meta = with lib; {
      description = "Date Menu Formatter GNOME Shell extension";
      license = licenses.gpl3Plus;
      maintainers = [];
      homepage = "https://github.com/marcinjakubowski/date-menu-formatter";
    };
  }
