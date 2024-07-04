{pkgs, ...}: {
  extraLuaPackages = luaPkgs: with luaPkgs; [jsregexp];
  extraPython3Packages = pyPkgs:
    with pyPkgs; [
      python-lsp-server
      python-lsp-ruff
      # pylsp-mypy
    ];
  extraPackages = with pkgs; [
    # Essentials
    nodePackages.npm
    nodePackages.neovim
    tree-sitter
    fswatch
    gnumake
    cmake

    # Telescope dependencies
    manix
    ripgrep
    fd

    # Lua
    lua-language-server
    stylua

    # Nix
    statix
    alejandra
    nil

    # C, C++
    gcc
    clang-tools
    cppcheck

    # Shell scripting
    shfmt
    shellcheck
    shellharden

    # JavaScript
    deno
    prettierd
    eslint_d
    nodePackages.prettier
    nodePackages.typescript-language-server
    nodePackages."@astrojs/language-server"
    # nodePackages.prettier-plugin-astro
    nodePackages-extra.prettier-plugin-astro

    # Go
    go
    gopls
    golangci-lint
    delve
    gotools
    go-tools
    gofumpt

    #clj
    clojure-lsp
    leiningen
    babashka

    #docker
    hadolint

    #markdown
    marksman

    # Additional
    yamllint
    bash-language-server
    yaml-language-server
    dockerfile-language-server-nodejs
    vscode-langservers-extracted
    markdownlint-cli
    taplo-cli
    codespell
    gitlint
    terraform-ls
    actionlint
  ];
}
