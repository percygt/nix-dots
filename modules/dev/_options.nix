{ lib, pkgs, ... }:
{
  options.modules.dev = {
    ghq.enable = lib.mkEnableOption "Enable ghq";
    glab.enable = lib.mkEnableOption "Enable glab";
    gh.enable = lib.mkEnableOption "Enable gh";
    git.package = lib.mkOption {
      description = "Git package";
      type = lib.types.package;
      default = pkgs.git;
    };
    process-compose.enable = lib.mkEnableOption "Enable process-compose";
    jujutsu.enable = lib.mkEnableOption "Enable jujutsu";
    tools = {
      enable = lib.mkEnableOption "Enable devtools";
      editorExtraPackages = lib.mkOption {
        description = "Extrapackages for editor";
        type = lib.types.listOf lib.types.package;
        default = with pkgs; [
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
          # alejandra
          nixfmt-rfc-style
          nil
          nixd

          # Elixir
          elixir
          elixir_ls

          #php
          # php.packages.php-cs-fixer
          php.packages.php-codesniffer
          phpactor

          # rust
          fenix.minimal.toolchain
          rust-analyzer-nightly
          # cargo
          # clippy
          # rustc
          # rustfmt
          # rust-analyzer

          #zig
          zig
          zls

          # C, C++
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
          nodePackages.prettier
          # NOTE: Handled by Mason-Lspconfig
          # astro-language-server
          # svelte-language-server
          # vue-language-server

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
          old.lispPackages.quicklisp
          rlwrap

          #docker
          hadolint
          dockerfile-language-server-nodejs

          #markdown
          marksman

          #sql
          sqlfluff

          # tailwind
          tailwindcss-language-server

          # Additional
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
          taplo-cli
          codespell
          gitlint
          actionlint
        ];
      };
    };
  };
}
