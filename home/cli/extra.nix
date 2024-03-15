{pkgs, ...}:{
  programs = {
    jq.enable = true;
    aria2.enable = true;
    zoxide.enable = true;
  };
  home.packages = with pkgs; [
    # archive/compress
    unrar
    p7zip

    # dev
    ghq # for managing local git repo
    bfg-repo-cleaner # Git history cleaner
    cgdb # GNU Debugger
    onefetch # displays project information and code statistics for a local Git repository

    # network
    socat # multipurpose relay
    croc # encrypted file transfers between two computers

    # encryption
    age
    git-crypt

    # LLM
    ollama

    # utils
    gum
    glow # Render markdown on the CLI
    timg # terminal image viewer
    grc # Generic Colouriser
    xh # for sending HTTP requests
    yq # portable command-line YAML, JSON and XML processor
    trash-cli # Command Line Interface to FreeDesktop.org Trash
    tealdeer # tldr in rust
    clipboard-jh # the clipboard manager
    chafa # cli graphics
    poppler # pdf rendering tool
    yt-dlp # download youtube videos    
  ];
}
