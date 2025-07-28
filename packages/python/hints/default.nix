{
  lib,
  python3,
  fetchFromGitHub,
  gobject-introspection,
  wrapGAppsHook3,
  at-spi2-core,
  libwnck,
  gtk-layer-shell,
  grim,
}:
python3.pkgs.buildPythonApplication {
  pname = "hints";
  version = "2025-02-01";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AlfredoSequeida";
    repo = "hints";
    rev = "8ae81d866a991a7751b3818014a0cad015b6a440";
    hash = "sha256-c46EmdIVyAYmDhRgVc8Roump/DwHynKpj2/7mzxaNiY=";
  };

  disabled = python3.pkgs.pythonOlder "3.10";

  build-system = [
    python3.pkgs.setuptools
    gtk-layer-shell
  ];
  preBuild = ''
    export HINTS_EXPECTED_BIN_DIR="$out"
  '';
  dependencies =
    with python3.pkgs;
    [
      pygobject3
      pillow
      pyscreenshot
      opencv-python
      pyatspi
    ]
    ++ [ grim ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    at-spi2-core
    libwnck # for X11
  ];

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  meta = {
    description = "Navigate GUIs without a mouse by typing hints in combination with modifier keys";
    homepage = "https://github.com/AlfredoSequeida/hints";
    license = with lib.licenses; [ gpl3Only ];
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
