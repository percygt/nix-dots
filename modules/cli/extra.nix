{
  lib,
  config,
  pkgs,
  ...
}: {
  options.cli.extra.home.enable = lib.mkEnableOption "Enable extra";
  config = lib.mkIf config.cli.extra.home.enable {
    home.packages = with pkgs; [
      # dev
      bfg-repo-cleaner # Git history cleaner
      cgdb # GNU Debugger
      onefetch # displays project information and code statistics for a local Git repository

      # network
      socat # multipurpose relay
      croc # encrypted file transfers between two computers

      # encryption

      # LLM
      ollama

      # utils
      zoxide
      gum
      glow # Render markdown on the CLI
      timg # terminal image viewer
      grc # Generic Colouriser
      xh # for sending HTTP requests
      trash-cli # Command Line Interface to FreeDesktop.org Trash
      tealdeer # tldr in rust
      clipboard-jh # the clipboard manager
      chafa # cli graphics
      poppler # pdf rendering tool
      yt-dlp # download youtube videos
    ];
  };
}
