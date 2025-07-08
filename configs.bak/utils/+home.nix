{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # hints
    revanced-cli
  ];
}
