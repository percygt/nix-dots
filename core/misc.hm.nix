{ pkgs, ... }:
{
  home.packages = with pkgs; [
    scrcpy
    go-chromecast
    yaml2json
    duf # Disk Usage/Free Utility
    yq-go # portable command-line YAML, JSON and XML processor
    curl
    p7zip
    jq
    aria2
    gping # Ping, but with a graph
    xcp # An extended cp
    dogdns # Command-line DNS client

    impala # Network
    lazyjournal # TUI for journalctl, file system logs, as well as Docker and Podman containers

    #nix stuff
    nixos-shell
    devenv
    nixfmt-rfc-style
    deadnix
    statix
    nurl
    nix-tree
    nix-your-shell
    cachix
    json2nix
    nix-output-monitor
    nvd
    nix-search-cli
    nix-inspect
    nix-prefetch-scripts
    nix-prefetch-github
  ];

  programs = {
    bat = {
      enable = true;
      config.theme = "catppuccin";
      themes = {
        catppuccin = {
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "d2bbee4f7e7d5bac63c054e4d8eca57954b31471";
            hash = "sha256-x1yqPCWuoBSx/cI94eA+AWwhiSA42cLNUOFJl7qjhmw=";
          };
          file = "themes/Catppuccin Mocha.tmTheme";
        };
      };
    };
    btop = {
      enable = true;
      settings = {
        color_theme = "tokyo-night";
        theme_background = false;
        vim_keys = true;
      };
    };
  };
}
