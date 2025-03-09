{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.modules.cli.enable {
    home.packages = with pkgs; [
      # tui
      tdf # Tui-based PDF viewer
      ttyper # Terminal-based typing test
      manga-tui # Terminal-based manga reader and downloader with image support
      fx # Terminal JSON viewer
      htmlq # Like jq, but for HTML
      tabiew # CSV viewer
      serpl # Simple terminal UI for search and replace, ala VS Code
      sshs # Terminal user interface for SSH.
      atac # based on well-known clients such as Postman, Insomnia
      stable.termscp # file transfer and explorer, with support for SCP/SFTP/FTP/S3
      stable.visidata # interactive multitool for tabular data NOTE: dependency libolm tagged as insecure package
      wtfutil # personal information dashboard
      termshark
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
      bandwhich # A CLI utility for displaying current network utilization
      scc # A very fast accurate code counter with complexity calculations and COCOMO estimates written in pure Go

      # network
      socat # multipurpose relay
      croc # encrypted file transfers between two computers

      # LLM
      # ollama

      # utils
      glow # Render markdown on the CLI
      timg # terminal image viewer
      grc # Generic Colouriser
      xh # for sending HTTP requests
      trash-cli # Command Line Interface to FreeDesktop.org Trash
      chafa # cli graphics
      poppler # pdf rendering tool
    ];
  };
}
