{
  pkgs,
  colors,
  ...
}: let
  lazysql = pkgs.callPackage ../../nixpkgs/go/lazysql.nix {};
in {
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    unrar
    p7zip
    unar
    git
    
    # util
    file
    du-dust
    duf
    fd
    ripgrep
    glow
    timg
    grc
    ghq
    xh
    jq
    yq
    curl
    wget
    trash-cli
    distrobox
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

    # tui's
    termscp
    lazydocker
    visidata
    podman-tui
    wtf
    jqp
    youtube-tui
    gh-dash
    gpg-tui
    lazysql
  ];

  programs = {
    lazygit = {
      enable = true;
      settings = {
        git = {
          paging = {
            colorArg = "always";
            pager = "delta --color-only --dark --paging=never";
            useConfig = false;
          };
        };
      };
    };

    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [batdiff batman batpipe prettybat batgrep batwatch];
      config.theme = "Visual Studio Dark+";
    };

    micro = {
      enable = true;
      settings = {
        colorscheme = "simple";
        autosu = true;
      };
    };

    fzf = {
      enable = true;
      colors = {
        "bg+" = "#${colors.extra.azure}";
        bg = "#${colors.normal.black}";
        preview-bg = "#${colors.default.background}";
      };
      tmux = {
        enableShellIntegration = true;
        shellIntegrationOptions = [
          "-p 90%,75%"
          "--preview-window=right,60%,,"
        ];
      };
      defaultCommand = "fd --type file --hidden --exclude .git";
      defaultOptions = [
        "--border rounded"
        "--info=inline"
      ];
      # CTRL-T - $FZF_CTRL_T_COMMAND
      fileWidgetCommand = "rg --files --hidden -g !.git";
      fileWidgetOptions = ["--preview 'preview {}'"];
      # ALT-C - $FZF_ALT_C_COMMAND
      changeDirWidgetCommand = "fd --type directory --hidden --exclude .git";
      changeDirWidgetOptions = ["--preview 'preview {}'"];
    };
    eza = {
      enable = true;
      icons = true;
    };
    btop.enable = true;
    zoxide.enable = true;
  };
}
