{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.dev.home.enable {
    home.packages = with pkgs; [
      leiningen
      babashka
      ghidra-bin
      gdb
    ];
  };
}
