{ pkgs, ... }:
{
  home.packages = with pkgs; [
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