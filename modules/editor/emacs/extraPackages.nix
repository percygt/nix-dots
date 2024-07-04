{pkgs}:
with pkgs; [
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
  # nodePackages.prettier
  # nodePackages.typescript-language-server
  # nodePackages."@astrojs/language-server"
  # nodePackages.prettier-plugin-astro
  # nodePackages-extra.prettier-plugin-astro

  # Go
  go
  gopls
  golangci-lint
  delve
  go-tools
  gofumpt

  #clj
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
  parallel
  ripgrep
  fd
]
