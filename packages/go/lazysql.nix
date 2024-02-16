{
  buildGoModule,
  fetchFromGitHub,
  lib,
  xorg,
}:
buildGoModule rec {
  pname = "lazysql";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "jorgerojas26";
    repo = "lazysql";
    rev = "v${version}";
    hash = "sha256-1qxYrzbtdVAxJ7WQf0IbMhGnF7tiw4gmqjAq7Ytd9z8=";
  };

  vendorHash = "sha256-tgD6qoCVC1ox15VPJWVvhe4yg3R81ktMuW2dsaU69rY=";

  ldflags = ["-s" "-w" "-X main.version=${version}"];

  doCheck = false;
  buildInputs = [xorg.libX11 xorg.libX11.dev xorg.libX11.out];
  meta = with lib; {
    description = "A cross-platform TUI database management tool written in Go.";
    license = licenses.mit;
    mainProgram = "lazysql";
    platforms = platforms.linux;
  };
}
