{
  pkgs,
  lib,
  config,
  ...
}: let
  HM_NVIM = "${config.xdg.configHome}/home-manager/common/nvim";
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
  devicons = pkgs.vimUtils.buildVimPlugin {
    pname = "nvim-web-devicons";
    version = "2024-01-07";
    src = pkgs.fetchFromGitHub {
      owner = "percygt";
      repo = "nvim-web-devicons";
      rev = "c9f1e6d6663a9d305886f5deb0606062e89cfa99";
      hash = "sha256-BDUU6Lf/u1rs1sHobcgd/fJzJHgE5dHdiTzXi05Z54g=";
    };
    meta.homepage = "https://github.com/percygt/nvim-web-devicons";
  };
  better-escape = pkgs.vimUtils.buildVimPlugin {
    pname = "better-escape";
    version = "2024-01-08";
    src = pkgs.fetchFromGitHub {
      owner = "max397574";
      repo = "better-escape.nvim";
      rev = "d62cf3c04163a46f3895c70cc807f5ae68dd8ca1";
      hash = "sha256-2Q8t2FTMlt9NkQ+n3jNFxAh9eJpn7LU/NwLaoFiz2Ts=";
    };
    meta.homepage = "https://github.com/max397574/better-escape.nvim";
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
      if vim.loader then
        vim.loader.enable()
      end
      require("config.general")
      require("config.remaps")
      require("config.autocmds")
      require("config.tools.misc")
      require("config.ui.misc")
    '';

    plugins = with pkgs.stable-23-11.vimPlugins; [
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
      devicons
      # nvim-web-devicons
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
        plugin = mini-nvim;
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
        plugin = pkgs.vimPlugins.codeium-nvim;
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
      nvim-cursorline
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
      vim-maximizer
      vim-visual-multi
      vim-tmux-navigator
      todo-comments-nvim
      comment-nvim
      vim-surround
      vim-repeat
      plenary-nvim
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
      # codeium
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
    activation = {
      linkNvimSpell = lib.hm.dag.entryAfter ["linkGeneration"] ''
        [ -d "${config.xdg.configHome}/nvim/spell" ] || ln -s "${HM_NVIM}/spell" "${config.xdg.configHome}/nvim/spell"
      '';
    };
  };
  xdg.configFile = {
    "nvim/lua" = {
      recursive = true;
      source = ../../common/nvim/lua;
    };
    "nvim/ftdetect" = {
      recursive = true;
      source = ../../common/nvim/ftdetect;
    };
    "nvim/lua/config/colors.lua" = {
      text = ''
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
