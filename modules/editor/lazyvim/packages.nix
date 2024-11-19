{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.modules.editor.lazyvim.enable {
    programs.neovim = {
      extraLuaPackages =
        luaPkgs: with luaPkgs; [
          jsregexp
          magick
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
        prettierd
        eslint_d
        nodePackages.prettier
        typescript-language-server
        astro-language-server

        # Go
        go
        gopls
        delve
        golangci-lint
        golines
        gotools
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
    };
  };
}
