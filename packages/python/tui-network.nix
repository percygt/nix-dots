{
  lib,
  python3,
  fetchurl,
  fetchFromGitHub,
}:
let
  textual = python3.pkgs.buildPythonApplication {
    pname = "textual";
    version = "0.88.1";
    src = fetchurl {
      url = "https://pypi.org/packages/source/t/textual/textual-0.88.1.tar.gz";
      sha256 = "sha256-nFbZU9x9Go3fBqzJENkiQCfgJBZVH5KSDnD0Nb0o4GI=";
    };
    pyproject = true;

    nativeBuildInputs = [ python3.pkgs.poetry-core ];

    propagatedBuildInputs = with python3.pkgs; [
      markdown-it-py
      rich
      typing-extensions
      platformdirs
    ];

    passthru.optional-dependencies = with python3.pkgs; {
      syntax = [
        tree-sitter
        tree_sitter_languages
      ];
    };

    pythonImportsCheck = [ "textual" ];
  };
  fortune-python = python3.pkgs.buildPythonApplication {
    pname = "fortune-python";
    version = "1.1.1";
    src = fetchurl {
      url = "https://pypi.org/packages/source/f/fortune-python/fortune-python-1.1.1.tar.gz";
      sha256 = "sha256-F0LrNesABYlUbxsWvM1XOhENhIyO3rZhbSYEymICkZc=";
    };
    pyproject = true;

    build-system = [
      python3.pkgs.setuptools
    ];

    pythonImportsCheck = [
      "fortune"
    ];

    meta = {
      description = "A Fortune clone in Python";
      homepage = "https://pypi.org/project/fortune-python/";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ zxc ];
      mainProgram = "fortune-python";
    };
  };
in
python3.pkgs.buildPythonApplication {
  pname = "tui-network";
  version = "e25a1585a03e9d604a995c4431dcaf7888893fb7";
  src = fetchFromGitHub {
    owner = "Zatfer17";
    repo = "tui-network";
    rev = "e25a1585a03e9d604a995c4431dcaf7888893fb7";
    fetchSubmodules = false;
    sha256 = "sha256-FeI+FD+Q9Vx/xaMEEimd86x+TJVRt7YzUjUEf9DDjx8=";
  };
  pyproject = true;

  build-system = [
    python3.pkgs.poetry-core
  ];

  nativeBuildInputs = with python3.pkgs; [
    pythonRelaxDepsHook
  ];

  dependencies = [
    fortune-python
    textual
  ];

  pythonRelaxDeps = true;

  pythonImportsCheck = [
    "tui_network"
  ];

  meta = {
    description = "";
    homepage = "https://github.com/Zatfer17/tui-network";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "tui-network";
  };
}
