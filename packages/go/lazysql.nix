{
  buildGoModule,
  fetchFromGitHub,
  lib,
  xorg,
}:
buildGoModule rec {
  pname = "lazysql";
  version = "v0.2.9";

  src = fetchFromGitHub {
    owner = "jorgerojas26";
    repo = "lazysql";
    rev = "7cd8dd26935ba123d895d0ddf5fdb18db2055626";
    hash = "sha256-6aJrLkmebOhLrnVhl9cnbW1ZBt0vq8lR7Lhz9nPFr8Q=";
  };

  vendorHash = "sha256-celee8uyoirX+vtAww2iQJtRwJEHyfHL2mZA2muSRiQ=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  doCheck = false;
  buildInputs = [
    xorg.libX11
    xorg.libX11.dev
    xorg.libX11.out
  ];
  meta = with lib; {
    description = "A cross-platform TUI database management tool written in Go.";
    license = licenses.mit;
    mainProgram = "lazysql";
    platforms = platforms.linux;
  };
}
