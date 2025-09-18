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
      env = {
        GOBIN = ".local/share/go/bin";
        GOPATH = ".local/share/go";
      };
    };
    home.packages =
      (with pkgs; [
        gitu
        bunster # Compile shell scripts to static binaries
        babashka # Clojure babushka for the grey areas of Bash
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
      ++ config.modules.dev.tools.codingPackages;
  };
}
