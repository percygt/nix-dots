{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.modules.editor.neovim.enable {
    programs.neovim = {
      extraLuaPackages =
        luaPkgs: with luaPkgs; [
          jsregexp
          magick
          luacheck
        ];
      extraPackages = with pkgs; [
        (python3.withPackages (
          ps: with ps; [
            python-lsp-server
            python-lsp-ruff
            # pylsp-mypy
            pip
            pylatexenc
          ]
        ))
        nodejs
        yarn
        imagemagick
        nodePackages.npm
        nodePackages.pnpm
        nodePackages.neovim
        vscode-extensions.vadimcn.vscode-lldb.adapter
        tree-sitter
        fswatch
        gnumake
        cmake
        git
        mercurial

        #dashboard
        cowsay
        fortune-kind

        # Telescope dependencies
        manix
        fzf
        ripgrep
        fd

        # Lua
        lua-language-server
        stylua

        # Nix
        statix
        # alejandra
        nixfmt-rfc-style
        nil
        nixd

        #php
        php.packages.php-cs-fixer
        php.packages.php-codesniffer
        phpactor

        # rust
        cargo
        clippy
        rustc
        rustfmt
        rust-analyzer

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
        clojure-lsp
        leiningen
        babashka

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
        bash-language-server
        yaml-language-server
        vscode-langservers-extracted
        cmake-language-server
        markdownlint-cli2
        taplo-cli
        codespell
        gitlint
        terraform-ls
        actionlint
      ];
    };
  };
}
