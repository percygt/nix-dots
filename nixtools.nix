{pkgs, ...}:
# nix tooling
{
  home.packages = with pkgs; [
    alejandra
    deadnix
    statix
    nurl
    nix-tree
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
