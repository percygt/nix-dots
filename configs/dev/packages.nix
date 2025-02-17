{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nur.repos.dagger.dagger
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
  ];
}
