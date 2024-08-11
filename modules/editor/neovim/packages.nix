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
        ];
      extraPython3Packages =
        pyPkgs: with pyPkgs; [
          python-lsp-server
          python-lsp-ruff
          # pylsp-mypy
          pip
          pylatexenc
        ];
      extraPackages = with pkgs; [
        # Essentials
        (fenix.complete.withComponents [
          "cargo"
          "clippy"
          "rust-src"
          "rustc"
          "rustfmt"
          "rust-analyzer"
        ])
        imagemagick
        nodePackages.npm
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
        astro-language-server
        # nodePackages."@astrojs/language-server"

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
