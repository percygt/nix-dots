{pkgs, ...}: {
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    unrar
    p7zip

    # utils
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

    # tui's
    termscp
    lazydocker
    lazygit
  ];

  programs = {
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
      # Default command that is executed for fzf - $FZF_DEFAULT_COMMAND
      defaultCommand = "fd --type file --hidden --exclude .git";
      defaultOptions = [
        "--height 50%"
        "--layout=reverse"
        "--border"
      ];
      # CTRL-T - $FZF_CTRL_T_COMMAND
      fileWidgetCommand = "fd --type file --hidden --exclude .git";

      # ALT-C - $FZF_ALT_C_COMMAND
      changeDirWidgetCommand = "fd --type directory --hidden --exclude .git";
    };
    eza = {
      enable = true;
      icons = true;
      git = true;
    };
    btop.enable = true;
    zoxide.enable = true;
    ssh.enable = true;
  };
}
