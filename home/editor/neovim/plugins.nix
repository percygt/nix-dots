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
      config = ''
        require("config.ui.which-key")
        require("config.whichkeymaps")
      '';
    }
    {
      plugin = zen-mode-nvim;
      type = "lua";
      config = ''require("config.ui.zen-mode")'';
    }
    {
      plugin = conjure;
      type = "lua";
      config =
        /*
        lua
        */
        ''
          vim.g['conjure#mapping#prefix'] = ','
          vim.g['conjure#log#hud#width'] = 1
          vim.g['conjure#log#hud#height'] = 0.6
          vim.g['conjure#client#clojure#nrepl#connection#auto_repl#enabled'] = false
          vim.g['conjure#eval#gsubs'] = {
            ['do-comment'] = {'^%(comment[%s%c]', '(do '}
          }
          vim.g['conjure#eval#result_register'] = '*'
          vim.g['conjure#mapping#doc_word'] = '<localleader>K'
          vim.g['conjure#client_on_load'] = false
        '';
    } # devicons
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
    telescope-manix
    telescope-file-browser-nvim
    telescope-fzf-native-nvim
    telescope-undo-nvim
    # File Browser #---------------------------------------------------------------------------------------
    {
      plugin = mini-nvim;
      type = "lua";
      config = ''require("config.mini")'';
    }
    # Completion/motions #-------------------------------------------------------------------------------------
    {
      plugin = nvim-cmp;
      type = "lua";
      config = ''require("config.lsp.completion")'';
    }
    flash-nvim
    cmp-async-path
    cmp-buffer
    cmp-cmdline
    cmp-nvim-lsp
    cmp-nvim-lua
    cmp-under-comparator
    cmp_luasnip
    luasnip
    lspkind-nvim
    # nvim-autopairs
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
    clangd_extensions-nvim
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
      config = ''require("config.tools.betterescape")'';
    }
    {
      plugin = nvim-spectre;
      type = "lua";
      config = ''require("config.tools.spectre")'';
    }
    {
      plugin = pkgs.vimPlugins.obsidian-nvim;
      type = "lua";
      config = ''require("config.tools.obsidian")'';
    }
    markdown-preview-nvim
    todo-comments-nvim
    comment-nvim
    hydra-nvim
    multicursors-nvim
    vim-maximizer
    vim-tmux-navigator
    vim-repeat
    pkgs.vimPlugins.plenary-nvim
  ];
}
