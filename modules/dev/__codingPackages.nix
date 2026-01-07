pkgs: with pkgs; [
  # Python
  # python3Packages.python-lsp-server
  # python3Packages.python-lsp-ruff
  # python3Packages.pylsp-mypy
  python3Packages.pip
  python3Packages.pylatexenc
  basedpyright
  ruff

  # Lua
  lua-language-server
  stylua

  # Nix
  statix
  nixfmt-rfc-style
  nil
  nixd

  # Elixir
  stable.elixir
  stable.elixir-ls

  #php
  # php.packages.php-cs-fixer
  # pretty-php
  # php.packages.php-codesniffer
  # phpactor

  # rust
  rust-analyzer-nightly
  rust-minimal-toolchain
  # cargo
  # clippy
  # rustc
  # rustfmt
  # rust-analyzer

  #zig
  zig
  zls

  # C, C++
  cli11
  gcc
  clang-tools
  cppcheck
  cmake

  # Shell scripting
  shfmt
  shellcheck
  shellharden

  # JavaScript
  deno
  vtsls
  prettierd
  eslint_d
  stable.nodePackages.prettier
  # nodePackages."@vue/language-server"
  # nodePackages."@astrojs/language-server"
  # svelte-language-server

  # Go
  go
  gopls
  delve
  golangci-lint
  gomodifytags
  impl
  golines
  gotools
  gofumpt

  #clj
  clojure
  cljfmt
  clojure-lsp
  leiningen
  babashka

  # Common lisp
  sbcl
  # old.lispPackages.quicklisp
  rlwrap

  #docker
  hadolint
  docker-language-server
  # dockerfile-language-server

  #markdown
  marksman

  #sql
  # sqlfluff

  # tailwind
  tailwindcss-language-server

  #gtk
  nur.repos.shackra.gtkcsslanguageserver

  # Additional
  kdlfmt
  lemminx
  libxml2
  xmlstarlet
  yamllint
  terraform
  terraform-ls
  moreutils # parallel
  libxml2
  bash-language-server
  yaml-language-server
  vscode-langservers-extracted
  cmake-language-server
  markdownlint-cli2
  taplo # taplo-cli
  codespell
  gitlint
  actionlint
  tree-sitter
]
