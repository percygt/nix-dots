{pkgs, ...}: let
  lsp_servers = pkgs.writeText "lsp-servers.json" (builtins.toJSON (import ./lsp-servers.nix {inherit pkgs;}));
  # lsp_tools = pkgs.writeText "lsp-tools.json" (builtins.toJSON (import ./lsp-tools.nix {inherit pkgs;}));
in {
  plugins = with pkgs.stash.vimPlugins; [
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
    {
      plugin = zen-mode-nvim;
      type = "lua";
      config = ''require("config.ui.zen-mode")'';
    }
    # devicons
    nvim-web-devicons
    trouble-nvim
    dressing-nvim
    nvim-colorizer-lua
    smartcolumn-nvim
    twilight-nvim
    nvim-notify
    fidget-nvim
    nui-nvim
    noice-nvim
    # Fuzzy Finder/File Browser #-------------------------------------------------------------------------
    {
      plugin = telescope-nvim;
      type = "lua";
      config = ''require("config.tools.telescope")'';
    }
    telescope-file-browser-nvim
    telescope-fzf-native-nvim
    telescope-undo-nvim
    # File Browser #---------------------------------------------------------------------------------------
    {
      plugin = pkgs.vimPlugins.mini-nvim;
      type = "lua";
      config = ''require("config.ui.mini")'';
    }
    # Completion #-------------------------------------------------------------------------------------
    {
      plugin = nvim-cmp;
      type = "lua";
      config = ''require("config.lsp.completion")'';
    }
    cmp-path
    cmp-buffer
    cmp-cmdline
    cmp-nvim-lsp
    cmp-nvim-lua
    cmp_luasnip
    lspkind-nvim
    nvim-autopairs
    luasnip
    friendly-snippets
    # AI #-------------------------------------------------------------------------------------
    {
      plugin = codeium-nvim;
      type = "lua";
      config = ''require("config.lsp.codeium")'';
    }
    # Language Server #---------------------------------------------------------------------------------
    {
      plugin = nvim-lspconfig;
      type = "lua";
      config = ''require("config.lsp.lspconfig").setup_servers("${lsp_servers}")'';
    }
    # Formatting/Diagnostic/Code Action #---------------------------------------------------------------
    # {
    #   plugin = pkgs.vimPlugins.none-ls-nvim;
    #   type = "lua";
    #   config = ''require("config.lsp.nonels").setup_null_ls("${lsp_tools}")'';
    # }
    {
      plugin = conform-nvim;
      type = "lua";
      config = ''require("config.lsp.format")'';
    }
    {
      plugin = nvim-lint;
      type = "lua";
      config = ''require("config.lsp.lint")'';
    }
    {
      plugin = actions-preview-nvim;
      type = "lua";
      config = ''require("config.lsp.actions-preview")'';
    }
    # Syntax Highlighting/LSP based motion #------------------------------------------------------------
    {
      plugin = nvim-treesitter.withAllGrammars;
      type = "lua";
      config = ''require("config.lsp.treesitter")'';
    }
    lsp-format-nvim
    lsp_signature-nvim
    nvim-treesitter-textobjects
    neodev-nvim
    # # Session #------------------------------------------------------------------------------------------
    {
      plugin = neovim-session-manager;
      type = "lua";
      config = ''require("config.tools.session_manager")'';
    }
    # Database #-----------------------------------------------------------------------------------------
    {
      plugin = vim-dadbod;
      type = "lua";
      config = ''require("config.tools.database")'';
    }
    vim-dadbod-ui
    vim-dadbod-completion
    # Debug #--------------------------------------------------------------------------------------------
    {
      plugin = nvim-dap;
      type = "lua";
      config = ''require("config.tools.debug")'';
    }
    nvim-dap-ui
    nvim-dap-go
    nvim-dap-python
    nvim-dap-virtual-text
    # Git #----------------------------------------------------------------------------------------------
    {
      plugin = gitsigns-nvim;
      type = "lua";
      config = ''require("config.tools.git")'';
    }
    git-worktree-nvim
    # thePrimeagen #--------------------------------------------------------------------------------------
    {
      plugin = pkgs.vimPlugins.harpoon2;
      type = "lua";
      config = ''require("config.tools.harpoon2")'';
    }
    # Misc tools #----------------------------------------------------------------------------------------
    {
      plugin = better-escape;
      type = "lua";
      # config = ''require("config.tools.better-esc")'';
      config = ''require("better_escape").setup()'';
    }
    {
      plugin = nvim-spectre;
      type = "lua";
      config = ''require("spectre").setup()'';
    }
    {
      plugin = pkgs.vimPlugins.obsidian-nvim;
      type = "lua";
      config = ''require("config.tools.obsidian")'';
    }
    # hardtime-nvim
    # {
    #   plugin = "hard-time";
    #   type = "lua";
    #   config = ''require("hardtime").setup()'';
    # }

    lazygit-nvim
    markdown-preview-nvim
    todo-comments-nvim
    comment-nvim
    hydra-nvim
    multicursors-nvim
    vim-maximizer
    vim-tmux-navigator
    vim-surround
    vim-repeat
    plenary-nvim
  ];
}
