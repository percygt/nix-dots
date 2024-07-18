{
  pkgs,
  lib,
  config,
  ...
}: {
  options.cli.nixtools.home.enable = lib.mkEnableOption "Enable nix tools";
  config = lib.mkIf config.cli.nixtools.home.enable {
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
      nix-output-monitor
      nvd
      # stash.yaml2nix
      nix-prefetch-scripts
      nix-prefetch-github
    ];
  };
}
