{pkgs, ...}: {
  home.packages = with pkgs; [
    alejandra
    deadnix
    statix
    nurl
    nix-tree
    node2nix
    nix-your-shell
    cachix
    json2nix
    # stash.yaml2nix
    nix-prefetch-scripts
    nix-prefetch-github
  ];
}
