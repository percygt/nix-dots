{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "tuya-ipc-terminal";
  version = "unstable-2025-05-31";

  src = fetchFromGitHub {
    owner = "seydx";
    repo = "tuya-ipc-terminal";
    rev = "d65b3e9babb4829176290b4d53195d62636f00bf";
    hash = "sha256-aZWfxrqD1UCpdgtxuHVIB4WagO7eXGgg17iH6u7ujuU=";
  };

  vendorHash = "sha256-O+uzwuSHVVEW/S3v7iVjYjA1d3g4bKhDSOEHEpldPl4=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "CLI tool to stream Tuya Smart Cameras via RTSP";
    homepage = "https://github.com/seydx/tuya-ipc-terminal";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ percygt ];
    mainProgram = "tuya-ipc-terminal";
  };
}
