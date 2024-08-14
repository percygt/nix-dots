{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # alejandra
    devenv
    nixfmt-rfc-style
    deadnix
    statix
    nurl
    nix-tree
    nix-your-shell
    cachix
    json2nix
    nix-melt
    nix-output-monitor
    nvd
    nix-search-cli
    # stash.yaml2nix
    nix-prefetch-scripts
    nix-prefetch-github
  ];
}
