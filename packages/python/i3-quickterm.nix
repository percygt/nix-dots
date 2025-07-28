{
  buildPythonPackage,
  fetchPypi,
  i3ipc,
  lib,
  ...
}:
buildPythonPackage rec {
  pname = "i3-quickterm";
  version = "1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "sha256-znZEVqhNcvpVKZC5+jrKaGU17DiZscIIEnWPzQVR9M4=";
  };
  dependencies = [ i3ipc ];
  doCheck = false;

  preBuild = ''
    sed -i '/TERMS = {/a\    "wezterm": TERM("wezterm", execopt="start", titleopt=None),' i3_quickterm/main.py
  '';

  meta = with lib; {
    description = "A small drop-down terminal for i3wm and sway";
    license = licenses.mit;
    mainProgram = "i3-quickterm";
    platforms = platforms.linux;
  };
}
