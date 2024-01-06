{pkgs, ...}: let
  lsp_servers = pkgs.writeText "lsp-servers.json" (builtins.toJSON (import ./lsp-servers.nix {inherit pkgs;}));
  lsp_tools = pkgs.writeText "lsp-tools.json" (builtins.toJSON (import ./lsp-tools.nix {inherit pkgs;}));
  colors = (import ../../colors.nix).syft;
  neovim-session-manager = pkgs.vimUtils.buildVimPlugin {
    pname = "neovim-session-manager";
    version = "2024-01-03";
    src = pkgs.fetchFromGitHub {
      owner = "Shatur";
      repo = "neovim-session-manager";
      rev = "68dde355a4304d83b40cf073f53915604bdd8e70";
      hash = "sha256-WOJQ6RIibOby+Pmzr6kQxcT2NCGrq1roWkh4QKJECks=";
    };
    meta.homepage = "https://github.com/Shatur/neovim-session-manager";
  };
  vim-maximizer = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-maximizer";
    version = "2024-01-01";
    src = pkgs.fetchFromGitHub {
      owner = "szw";
      repo = "vim-maximizer";
      rev = "2e54952fe91e140a2e69f35f22131219fcd9c5f1";
      hash = "sha256-+VPcMn4NuxLRpY1nXz7APaXlRQVZD3Y7SprB/hvNKww=";
    };
    meta.homepage = "https://github.com/szw/vim-maximizer";
  };
in {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly.overrideAttrs (_: {CFLAGS = "-O3";});
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = false;
    extraLuaConfig = ''
      require("config.general")
      require("config.remaps")
      require("config.autocmds")
      require("config.tools.misc")
      require("config.ui.misc")
    '';

    plugins = with pkgs.stable-23-11.vimPlugins; [
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
      # Language Servers #-------------------------------------------------------------------------------------
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''require("config.lsp.lspconfig").setup_servers("${lsp_servers}")'';
      }
      # Formatting/Diagnostic/Code Action #------------------------------------------------------------------------------------
      {
        plugin = none-ls-nvim;
        type = "lua";
        config = ''require("config.lsp.nonels").setup_null_ls("${lsp_tools}")'';
      }
      # Syntax Highlighting/LSP based motions #-------------------------------------------------------------------------------------
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''require("config.lsp.treesitter")'';
      }
      lsp-format-nvim
      lsp_signature-nvim
      nvim-treesitter-textobjects
      neodev-nvim
      nvim-cursorline
      # Sessions #-------------------------------------------------------------------------------------
      # {
      #   plugin = auto-session;
      #   type = "lua";
      #   config = ''require("config.tools.auto-session")'';
      # }
      {
        plugin = neovim-session-manager;
        type = "lua";
        config = ''require("config.session_manager")'';
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
      nvim-dap-virtual-text
      # Git #-------------------------------------------------------------------------------------
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = ''require("config.tools.git")'';
      }
      git-worktree-nvim
      # thePrimeagen #-------------------------------------------------------------------------------------
      {
        plugin = pkgs.vimPlugins.harpoon2;
        type = "lua";
        config = ''require("config.tools.harpoon2")'';
      }
      # Misc tools #-------------------------------------------------------------------------------------
      vim-visual-multi
      vim-tmux-navigator
      vim-maximizer
      todo-comments-nvim
      comment-nvim
      vim-surround
      vim-repeat
      plenary-nvim
      # UI Enhancement #-------------------------------------------------------------------------------------
      {
        plugin = onedark-nvim;
        type = "lua";
        config = ''require("config.ui.theme")'';
      }
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
        plugin = which-key-nvim;
        type = "lua";
        config = ''require("config.ui.which-key")'';
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
      telescope-fzf-native-nvim
      telescope-undo-nvim
      # File Browser #-------------------------------------------------------------------------------------
      {
        plugin = mini-nvim;
        type = "lua";
        config = ''require("config.mini")'';
      }
      # {
      #   plugin = oil-nvim;
      #   type = "lua";
      #   config = ''require("config.oil")'';
      # }
      # {
      #   plugin = nvim-tree-lua;
      #   type = "lua";
      #   config = ''require("config.tree")'';
      # }
    ];
    extraPackages = with pkgs; [
      # Essentials
      nodePackages.pnpm
      nodePackages.neovim

      # Telescope dependencies
      ripgrep
      fd
      fzf

      # python
      nodePackages.pyright
      ruff
      ruff-lsp

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
      nodePackages.prettier
      nodePackages.typescript-language-server
      nodePackages."@astrojs/language-server"
      nodePackages-extra.prettier-plugin-astro

      # Go
      go
      gopls
      golangci-lint
      delve

      #docker
      hadolint

      # Additional
      yamllint
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
  xdg.configFile."nvim/lua/config/colors.lua" = {
    text = ''
      return {
        bg0 = "#${colors.normal.black}",
        bg1 = "#${colors.bright.black}",
        bg2 = "#${colors.extra.nocturne}",
        bg3 = "#${colors.extra.azure}",
        bg_d = "#${colors.extra.obsidian}",
        fg = "#${colors.default.foreground}",
        yellow = "#${colors.normal.yellow}",
        cyan = "#${colors.normal.cyan}",
        matchParen = "#${colors.bright.blue}",

        --Catpuccin stuff
        lavender = "#${colors.extra.lavender}",
        rosewater = "#${colors.extra.rosewater}",
        peach = "#${colors.extra.peach}",
        sapphire = "#${colors.extra.sapphire}",
        sky = "#${colors.extra.sky}",
        mauve = "#${colors.extra.mauve}",
      }
    '';
  };
}
