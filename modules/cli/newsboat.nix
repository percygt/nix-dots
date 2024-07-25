{ config, lib, ... }:
{
  options.modules.cli.newsboat.enable = lib.mkEnableOption "Enable newsboat";
  config = lib.mkIf config.modules.cli.newsboat.enable {
    programs.newsboat = {
      enable = true;
    };
  };
}
