{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nixos-shell
    devenv
    nixfmt-rfc-style
    deadnix
    statix
    nurl
    nix-tree
    nix-your-shell
    cachix
    json2nix
    nix-output-monitor
    nvd
    nix-search-cli
    nix-inspect
    # stash.yaml2nix
    nix-prefetch-scripts
    nix-prefetch-github
  ];
}
