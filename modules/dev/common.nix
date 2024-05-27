{pkgs, ...}: {
  home.packages = with pkgs; [
    devenv
    leiningen
    babashka
  ];
}
