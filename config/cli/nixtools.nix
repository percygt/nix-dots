{ pkgs, inputs, ... }:
{
  imports = [
    inputs.nixos-cli.nixosModules.nixos-cli
  ];
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
    # nix-melt
    nix-output-monitor
    nvd
    nix-search-cli
    nix-inspect
    # stash.yaml2nix
    nix-prefetch-scripts
    nix-prefetch-github
  ];
}
