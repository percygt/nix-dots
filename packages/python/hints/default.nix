{
  lib,
  python3,
  fetchFromGitHub,
  gobject-introspection,
  wrapGAppsHook3,
  at-spi2-core,
  libwnck,
  gtk-layer-shell,
}:
python3.pkgs.buildPythonApplication {
  pname = "hints";
  version = "2025-02-01";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AlfredoSequeida";
    repo = "hints";
    rev = "f1d2aff2f5849f81927fc9ef23e448d8080d9973";
    hash = "sha256-9Ae2dUvUCFavF59jAlHgRohPMF2zf5W+O+71NtSGJaE=";
  };

  disabled = python3.pkgs.pythonOlder "3.10";

  build-system = with python3.pkgs; [ setuptools ];

  dependencies =
    with python3.pkgs;
    [
      pygobject3
      pillow
      pyscreenshot
      opencv-python
      pyatspi
    ]
    ++ (
      if pkgs.stdenv.isLinux && builtins.getEnv "XDG_SESSION_TYPE" == "wayland" then
        [
          gtk-layer-shell
          grim
        ]
      else
        [ ]
    );

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    at-spi2-core
    libwnck # for X11
  ];

  patches = [ ./get_window_system.diff ];

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  meta = {
    description = "Navigate GUIs without a mouse by typing hints in combination with modifier keys";
    homepage = "https://github.com/AlfredoSequeida/hints";
    license = with lib.licenses; [ gpl3Only ];
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
