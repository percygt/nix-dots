{pkgs, ...}: let
  lsp_servers = pkgs.writeText "lsp-servers.json" (builtins.toJSON (import ./lsp-servers.nix {inherit pkgs;}));
  lsp_tools = pkgs.writeText "lsp-tools.json" (builtins.toJSON (import ./lsp-tools.nix {inherit pkgs;}));
in {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly.overrideAttrs (_: {CFLAGS = "-O3";});
    vimAlias = true;
    viAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = false;
    extraConfig = ''
      let mapleader=" "

      lua <<EOF
      require("config.general")
      require("config.keymaps")
      EOF
    '';

    plugins = with pkgs.stable.vimPlugins; [
      # Completion #-------------------------------------------------------------------------------------
      {
        plugin = nvim-cmp;
        type = "lua";
        config = ''require("config.lsp.completion")'';
      }
      cmp-path
      cmp-buffer
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp_luasnip
      lspkind-nvim
      nvim-autopairs
      luasnip
      friendly-snippets
      # Language Server #-------------------------------------------------------------------------------------
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''require("config.lsp.lspconfig").setup_servers("${lsp_servers}")'';
      }
      # Formatting/Diagnostic/Code Action #------------------------------------------------------------------------------------
      {
        plugin = none-ls-nvim;
        type = "lua";
        config = ''require("config.lsp.nonels").setup_servers("${lsp_tools}")'';
      }
      # Syntax Highlighting/LSP based motions #-------------------------------------------------------------------------------------
      {
        plugin = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''require("config.lsp.treesitter")'';
      }
      nvim-treesitter-textobjects
      nvim-cursorline
      # Sessions #-------------------------------------------------------------------------------------
      {
        plugin = auto-session;
        type = "lua";
        config = ''require("config.tools.auto-session")'';
      }
      # Database #-------------------------------------------------------------------------------------
      {
        plugin = vim-dadbod;
        type = "lua";
        config = ''require("config.tools.database")'';
      }
      vim-dadbod-ui
      vim-dadbod-completion
      # Debug #-------------------------------------------------------------------------------------
      {
        plugin = nvim-dap;
        type = "lua";
        config = ''require("config.tools.debug")'';
      }
      nvim-dap-ui
      nvim-dap-go
      nvim-dap-python
      # Git #-------------------------------------------------------------------------------------
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = ''require("config.tools.git")'';
      }
      git-worktree-nvim
      # thePrimeagen #-------------------------------------------------------------------------------------
      {
        plugin = harpoon2;
        type = "lua";
        config = ''require("config.tools.harpoon2")'';
      }
      comment-nvim
      vim-surround
      vim-repeat
      vim-maximizer
      plenary-nvim
      # UI Enhancement #-------------------------------------------------------------------------------------
      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config = ''require("config.ui.indent")'';
      }
      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''require("config.ui.lualine")'';
      }
      {
        plugin = onedark-nvim;
        type = "lua";
        config = ''require("config.ui.theme")'';
      }
      {
        plugin = which-key-nvim;
        type = "lua";
        config = ''require("which-key")'';
      }
      trouble-nvim
      dressing-nvim
      nvim-colorizer-lua
      smartcolumn-nvim
      twilight-nvim
      nvim-web-devicons
      nvim-notify
      fidget-nvim
      nui-nvim
      noice-nvim
      # Fuzzy Finder/File Browser #-------------------------------------------------------------------------------------
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''require("config.telescope")'';
      }
      telescope-file-browser-nvim
      # File Tree Browser #-------------------------------------------------------------------------------------
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = ''require("config.tree")'';
      }
    ];
    extraPackages = with pkgs; [
      # Essentials
      nodePackages.npm
      nodePackages.neovim

      # Telescope dependencies
      ripgrep
      fd

      (python3.withPackages (ps:
        with ps; [
          setuptools # Required by pylama for some reason
          pylama
          black
          isort
          ruff
          debugpy
        ]))
      nodePackages.pyright
      pyupgrade
      yamllint

      # Lua
      lua-language-server
      selene

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
      nodePackages.prettier
      nodePackages.eslint
      nodePackages.typescript-language-server

      # Go
      go
      gopls
      golangci-lint
      delve

      # Additional
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
  };

  xdg.configFile.nvim = {
    recursive = true;
    source = ../../common/nvim;
  };
}
