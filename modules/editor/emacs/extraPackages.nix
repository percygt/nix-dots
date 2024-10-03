{ pkgs }:
with pkgs;
[
  (texlive.combine {
    inherit (pkgs.texlive)
      dvisvgm
      dvipng # for preview and export as html
      wrapfig
      amsmath
      ulem
      hyperref
      capt-of
      scheme-minimal
      latex-bin
      latexmk
      tools
      pgf
      epstopdf-pkg
      nicematrix
      infwarerr
      grfext
      kvdefinekeys
      kvsetkeys
      kvoptions
      ltxcmds
      ;
  })
  (python3.withPackages (
    ps: with ps; [
      python-lsp-server
      # pylsp-mypy
      python-lsp-ruff
    ]
  ))
  # ruff
  # nodePackages.pyright

  # Lua
  lua-language-server
  stylua

  # Nix
  statix
  # alejandra
  nixfmt-rfc-style
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
  pkgs.stable.vscode-langservers-extracted
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
