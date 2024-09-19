{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  coreutils-full,
  libnotify,
}:

stdenv.mkDerivation {
  pname = "pomo-sh";
  version = "2024-09-08-git";

  src = fetchFromGitHub {
    owner = "percygt";
    repo = "pomo";
    rev = "506930223c0fd1065e94b2424330f5a71b66f6a9";
    hash = "sha256-VDm/1fsc45IE8lLq2SRq6+fyhX4JL5rdGvo0SGY00c0=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 pomo.sh $out/bin/pomo

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/pomo --prefix PATH : ${
      lib.makeBinPath [
        coreutils-full
        libnotify
      ]
    }
  '';

  meta = {
    description = "A simple Pomodoro timer written in Bash";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ ];
    mainProgram = "pomo";
  };
}
