{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.modules.dev.enable {
    home.packages = with pkgs; [
      babashka
      bfg-repo-cleaner # Git history cleaner
    ];
  };
}
