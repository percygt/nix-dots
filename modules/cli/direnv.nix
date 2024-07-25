{ lib, config, ... }:
{
  options.modules.cli.direnv.enable = lib.mkEnableOption "Enable direnv";
  config = lib.mkIf config.modules.cli.direnv.enable {
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
