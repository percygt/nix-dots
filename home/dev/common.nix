{pkgs, ...}: {
  home.packages = with pkgs; [
    leiningen
    babashka
    ghidra-bin
    gdb
  ];
}
