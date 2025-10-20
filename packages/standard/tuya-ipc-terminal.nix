{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "tuya-ipc-terminal";
  version = "unstable-2025-10-15";

  src = fetchFromGitHub {
    owner = "percygt";
    repo = "tuya-ipc-terminal";
    rev = "75b29ebe76b46e5653511e92f4ee0bb97f41afd0";
    hash = "sha256-Ys4GD9f28vrMEaCl2IY5wA61+tkoeic6JBnmUTd4VNE=";
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
