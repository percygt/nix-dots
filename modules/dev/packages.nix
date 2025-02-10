{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.modules.dev.enable {
    programs.go = {
      enable = true;
      goPath = ".local/share/go";
      goBin = ".local/share/go/bin";
    };
    home.packages =
      (with pkgs; [
        babashka
        bfg-repo-cleaner # Git history cleaner
      ])
      ++ config.modules.dev.editorExtraPackages;
  };
}
