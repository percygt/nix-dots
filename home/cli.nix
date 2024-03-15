{
  pkgs,
  colors,
  ...
}: let
  lazysql = pkgs.callPackage ../packages/go/lazysql.nix {};
in {
  home.packages = with pkgs; [
    lazysql
    # archives
    zip
    unzip
    unrar
    p7zip
    unar
    git-crypt

    # tools
    git
    file
    du-dust
    duf
    fd
    ripgrep
    glow
    timg
    grc # Generic Colouriser
    ghq
    xh
    jq
    yq
    curl
    wget
    trash-cli
    # distrobox
    socat
    tealdeer
    croc
    ollama
    zoxide
    plocate
    libsixel
    clipboard-jh
    pinentry-gnome
    chafa
    cgdb
    poppler
    ffmpegthumbnailer
    mpv
    onefetch
    yt-dlp
    bfg-repo-cleaner
    age

    # tui's
    termscp
    lazydocker
    visidata
    podman-tui
    wtf
    jqp
    youtube-tui
    gpg-tui
    lazysql
  ];

  programs = {
    btop.enable = true;
    zoxide.enable = true;
  };
}
