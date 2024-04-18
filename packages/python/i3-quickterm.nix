{
  buildPythonPackage,
  fetchPypi,
  i3ipc,
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
  dependencies = [
    i3ipc
  ];
  doCheck = false;
}
