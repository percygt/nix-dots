{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.modules.cli.common.enable = lib.mkEnableOption "Enable common cli tools";
  config = lib.mkIf config.modules.cli.common.enable {
    programs = {
      btop = {
        enable = true;
        settings = {
          color_theme = "tokyo-night";
          theme_background = false;
          vim_keys = true;
        };
      };
      lazygit = {
        enable = true;
        settings = {
          gui = {
            nerdFontsVersion = "3";
            theme = {
              activeBorderColor = [
                "yellow"
                "bold"
              ];
              inactiveBorderColor = [ "cyan" ];
            };
          };
        };
      };
    };
    home.packages = with pkgs; [
      # tui
      nvtopPackages.full
      termscp # file transfer and explorer, with support for SCP/SFTP/FTP/S3
      # visidata # interactive multitool for tabular data
      wtf # personal information dashboard
      bluetuith
      lazydocker
      lazysql
      podman-tui
      jqp
      gpg-tui
      tailscale
      ripgrep # A utility that combines the usability of The Silver Searcher with the raw speed of grep
      jdupes # A powerful duplicate file finder and an enhanced fork of 'fdupes'
      viddy # A modern watch command
      hyperfine # Command-line benchmarking tool
      most # A terminal pager similar to 'more' and 'less'
      procs # A modern replacement for ps written in Rust
      exiftool # A tool to read, write and edit EXIF meta information
      sd # Intuitive find & replace CLI (sed alternative)
      entr # Run arbitrary commands when files change
      glances # Cross-platform curses-based monitoring tool
      cointop # The fastest and most interactive terminal based UI application for tracking cryptocurrencies
      ddgr # Search DuckDuckGo from the terminal
      buku # Private cmdline bookmark manager
      mutt # A small but very powerful text-based mail client
      navi # An interactive cheatsheet tool for the command-line and application launchers
      bandwhich # A CLI utility for displaying current network utilization
      scc # A very fast accurate code counter with complexity calculations and COCOMO estimates written in pure Go
      git
      dust
      dua # Tool to conveniently learn about the disk usage of directories
      duf # Disk Usage/Free Utility
      yq-go # portable command-line YAML, JSON and XML processor
      fd
      curlie
      p7zip
      jq
      aria2
      gping # Ping, but with a graph
      xcp # An extended cp
      dogdns # Command-line DNS client
      dive # A tool for exploring each layer in a docker image
    ];
  };
}
