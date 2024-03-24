{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    cli.nixtools.enable =
      lib.mkEnableOption "Enable nix tools";
  };

  config = lib.mkIf config.cli.nixtools.enable {
    home.packages = with pkgs; [
      alejandra
      deadnix
      statix
      nurl
      nix-tree
      node2nix
      nix-your-shell
      cachix
    ];
  };
}
