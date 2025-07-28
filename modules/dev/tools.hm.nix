{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.modules.dev.tools.enable {
    programs.go = {
      enable = true;
      goPath = ".local/share/go";
      goBin = ".local/share/go/bin";
    };
    home.packages =
      (with pkgs; [
        babashka
        bfg-repo-cleaner # Git history cleaner
        # nur.repos.dagger.dagger
        duckdb
        python3Packages.howdoi # Instant coding answers via the command line
        teller # Cloud native secrets management for developers
        dive # A tool for exploring each layer in a docker image
        onefetch # displays project information and code statistics for a local Git repository
        lazydocker
        lazysql
        podman-tui
        # build tools / command runners
        gnumake
        just
        go-task
      ])
      ++ config.modules.dev.tools.editorExtraPackages;
  };
}
