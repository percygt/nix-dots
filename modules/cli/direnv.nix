{
  lib,
  config,
  ...
}: {
  options = {
    cli.direnv.enable =
      lib.mkEnableOption "Enable direnv";
  };

  config = lib.mkIf config.cli.direnv.home.enable {
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
