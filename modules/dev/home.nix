{ lib, ... }:
{
  imports = [
    ./git
    ./go.nix
    ./common.nix
    ./jujutsu.nix
  ];
  options.dev.home.enable = lib.mkEnableOption "Enable devtools home";
}
