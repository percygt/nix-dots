{pkgs, ...}: {
  extraPackages = with pkgs; [
    # Essentials
    nodePackages.npm
    nodePackages.neovim

    # Telescope dependencies
    ripgrep
    fd
    fzf

    # python
    (python3.withPackages (ps:
      with ps; [
        python-lsp-server
        # pylsp-mypy
        python-lsp-ruff
      ]))
    # ruff
    # nodePackages.pyright

    # Lua
    lua-language-server
    stylua

    # Nix
    statix
    alejandra
    nil

    # C, C++
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
    nodePackages-extra.prettier-plugin-astro

    # Go
    go
    gopls
    golangci-lint
    delve

    #docker
    hadolint

    #markdown
    marksman

    # Additional
    yamllint
    nodePackages.bash-language-server
    nodePackages.yaml-language-server
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.vscode-langservers-extracted
    nodePackages.markdownlint-cli
    taplo-cli
    codespell
    gitlint
    terraform-ls
    actionlint
  ];
}
