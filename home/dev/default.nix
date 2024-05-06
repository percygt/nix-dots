{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./git
    ./go.nix
  ];

  dev = {
    git.enable = lib.mkDefault true;
  };
  home.packages = with pkgs; [
    leiningen
    babashka
  ];
}
