{ pkgs }:
with pkgs;
[
  ## binaries
  straight-el
  # dirvish deps
  poppler
  ffmpegthumbnailer
  mediainfo
  gnutar
  unzip
  binutils # native-comp needs 'as', provided by this
  ## Dependencies
  git
  ripgrep
  gnutls # for TLS connectivity
  ## Optional dependencies
  fd # faster projectile indexing
  imagemagick # for image-dired
  # (lib.mkIf config.programs.gnupg.agent.enable pinentry-emacs) # in-emacs gnupg prompts
  zstd # for undo-fu-session/undo-tree compression
  ## Module dependencies
  # :email mu4e
  mu
  isync
  # :checkers spell
  (aspellWithDicts (
    dicts: with dicts; [
      en
      en-computers
      en-science
      es
    ]
  ))
  # :tools editorconfig
  editorconfig-core-c # per-project style config
  # :tools lookup & :lang org +roam
  sqlite
  # :lang beancount
  beancount
  fava
  # :lang nix
  age
  # :lang latex
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
]
