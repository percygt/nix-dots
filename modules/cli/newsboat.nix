{ config, lib, ... }:
{
  options.cli.newsboat.home.enable = lib.mkEnableOption "Enable newsboat";
  config = lib.mkIf config.cli.newsboat.home.enable {
    programs.newsboat = {
      enable = true;
    };
  };
}
