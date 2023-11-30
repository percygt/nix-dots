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

    # tui's
    termscp
    lazydocker
    lazygit
  ];

  programs = {
    bat = {
      enable = true;
      config = {
        pager = "less -FR";
        theme = "base16";
      };
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
      defaultOptions = [
        "--height 50%"
        "--layout=reverse"
        "--border"
      ];
    };
    thefuck.enable = true;
    btop.enable = true;
    eza.enable = true;
    ssh.enable = true;
  };
}
