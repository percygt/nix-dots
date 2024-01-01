{pkgs, ...}:
# nix tooling
{
  home.packages = with pkgs; [
    alejandra
    deadnix
    statix
    nurl
    nix-tree
    nixgl
  ];
}
