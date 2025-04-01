{ lib, pkgs, ... }:
{
  options.modules.dev = {
    enable = lib.mkEnableOption "Enable dev";
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
        stable.basedpyright
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
        stable.sqlfluff

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
}
