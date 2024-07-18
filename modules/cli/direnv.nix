{ lib, config, ... }:
{
  options.cli.direnv.home.enable = lib.mkEnableOption "Enable direnv";
  config = lib.mkIf config.cli.direnv.home.enable {
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
      config = {
        global = {
          strict_env = true;
          warn_timeout = "30s";
        };
      };
    };
  };
}
