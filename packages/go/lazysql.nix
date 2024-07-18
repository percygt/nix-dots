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
    rev = "509f881d8cf93933b3f7859962f5bd6562d7cdd7";
    hash = "sha256-thlfGw5E5maarcdOcPdggHaJ7H4TnIFw9I0pQ9npUqo=";
  };

  vendorHash = "sha256-tgD6qoCVC1ox15VPJWVvhe4yg3R81ktMuW2dsaU69rY=";

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
