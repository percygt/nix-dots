{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.modules.cli.nixtools.enable = lib.mkEnableOption "Enable nix tools";
  config = lib.mkIf config.modules.cli.nixtools.enable {
    home.packages = with pkgs; [
      # alejandra
      nixfmt-rfc-style
      deadnix
      statix
      nurl
      nix-tree
      node2nix
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
  };
}
