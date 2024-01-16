{pkgs, ...}: let
  colors = (import ./colors.nix).syft;
in {
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
        "--border"
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
      git = true;
    };
    btop.enable = true;
    zoxide.enable = true;
    ssh.enable = true;
  };
}
