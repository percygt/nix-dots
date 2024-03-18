{
  pkgs,
  lib,
  config,
  flakeDirectory,
  ui,
  ...
}: let
  inherit (ui) colors;
  lsp_servers = pkgs.writeText "lsp-servers.json" (builtins.toJSON (import ./lsp-servers.nix {inherit pkgs;}));
  lsp_tools = pkgs.writeText "lsp-tools.json" (builtins.toJSON (import ./lsp-tools.nix {inherit pkgs;}));
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
      if vim.loader then
        vim.loader.enable()
      end
      require("config.general")
      require("config.remaps")
      require("config.autocmds")
      require("config.tools.misc")
      require("config.ui.misc")
    '';

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
      {
        plugin = none-ls-nvim;
        type = "lua";
        config = ''require("config.lsp.nonels").setup_null_ls("${lsp_tools}")'';
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
      # Session #------------------------------------------------------------------------------------------
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
        config = ''require("config.tools.better-esc")'';
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
    extraPackages = with pkgs; [
      # Essentials
      nodePackages.npm
      nodePackages.neovim

      # Telescope dependencies
      ripgrep
      fd
      fzf

      # python
      (python3.withPackages (ps:
        with ps; [
          python-lsp-server
          # pylsp-mypy
          python-lsp-ruff
        ]))
      # nodePackages.pyright

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

      #markdown
      marksman

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
  home = {
    activation = let
      HM_NVIM = "${flakeDirectory}/home/_config/nvim";
    in {
      linkNvimSpell =
        lib.hm.dag.entryAfter ["linkGeneration"]
        ''
          [ -e "${config.xdg.configHome}/nvim/spell" ] || ln -s "${HM_NVIM}/spell" "${config.xdg.configHome}/nvim/spell"
        '';
    };
  };
  xdg.configFile = {
    "nvim/lua" = {
      recursive = true;
      source = ../_config/nvim/lua;
    };
    "nvim/ftdetect" = {
      recursive = true;
      source = ../_config/nvim/ftdetect;
    };
    "nvim/lua/config/colors.lua" = {
      text =
        /*
        lua
        */
        ''
          return {
            bg0 = "#${colors.normal.black}",
            bg1 = "#${colors.bright.black}",
            bg2 = "#${colors.extra.nocturne}",
            bg3 = "#${colors.extra.azure}",
            bg_d = "#${colors.extra.obsidian}",
            fg = "#${colors.default.foreground}",
            -- yellow = "#${colors.normal.yellow}",
            cyan = "#${colors.normal.cyan}",
            matchParen = "#${colors.extra.azure}",
            midnight = "#${colors.extra.midnight}",
            cream = "#${colors.extra.cream}",

            -- Catpuccin stuff
            lavender = "#${colors.extra.lavender}",
            rosewater = "#${colors.extra.rosewater}",
            peach = "#${colors.extra.peach}",
            sapphire = "#${colors.extra.sapphire}",
            sky = "#${colors.extra.sky}",
            mauve = "#${colors.extra.mauve}",
          }
        '';
    };
  };
}
