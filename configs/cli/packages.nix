{ pkgs, ... }:
{
  home.packages = with pkgs; [
    navi
    zoxide
    yaml2json
    dua # Tool to conveniently learn about the disk usage of directories
    duf # Disk Usage/Free Utility
    yq-go # portable command-line YAML, JSON and XML processor
    curlie
    p7zip
    jq
    aria2
    gping # Ping, but with a graph
    xcp # An extended cp
    dogdns # Command-line DNS client
  ];
}
