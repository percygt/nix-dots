{pkgs, ...}: {
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
      ##../../common/nvim/lua/lsp.lua
      (
        let
          lspServers = pkgs.writeText "lsp-servers.json" (builtins.toJSON (import ./lsp-servers.nix {inherit pkgs;}));
        in {
          plugin = nvim-lspconfig;
          type = "lua";
          config = ''
            require("config.lsp").setup_servers("${lspServers}")
            require("config.lsp_cmp")
          '';
        }
      )
      # lsp_signature-nvim
      nvim-code-action-menu
      {
        plugin = nvim-lightbulb;
        type = "lua";
        config = ''
          require("nvim-lightbulb").setup({
            autocmd = { enabled = true }
          })
        '';
      }
      # {
      #   plugin = yaml-companion;
      #   type = "lua";
      #   config = ''
      #     require("telescope").load_extension("yaml_schema")
      #     local cfg = require("yaml-companion").setup({})
      #     require("lspconfig")["yamlls"].setup(cfg)
      #   '';
      # }
      {
        plugin = nvim-cmp;
        type = "lua";
        config = ''
          require("config.lsp_cmp")
        '';
      }
      lspkind-nvim
      cmp-path
      cmp-buffer
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp_luasnip
      nvim-autopairs
      {
        plugin = luasnip;
        type = "lua";
        config = ''
          require("config.snippets")
        '';
      }
      friendly-snippets

      {
        plugin = nvim-dap;
        type = "lua";
        config = ''
          require("config.debug")
        '';
      }
      nvim-dap-ui
      nvim-dap-go
      nvim-dap-python
      {
        plugin = refactoring-nvim;
        type = "lua";
        config = ''
          require("config.refactoring")
        '';
      }

      #-------------------------------------------------------------------------------------
      {
        plugin = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
          require("config.treesitter")
        '';
      }
      nvim-treesitter-textobjects
      nvim-ts-rainbow
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          require("config.telescope")
        '';
      }
      telescope-file-browser-nvim
      plenary-nvim
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = ''
          require("config.tree")
        '';
      }
      {
        plugin = which-key-nvim;
        type = "lua";
        config = ''
          vim.api.nvim_set_option("timeoutlen", 300)
          require("which-key").setup({})
        '';
      }
      {
        plugin = comment-nvim;
        type = "lua";
        config = ''
          require("config.comment")
        '';
      }
      vim-surround
      vim-repeat
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = ''
          require("gitsigns").setup()
        '';
      }

      {
        plugin = onedark-nvim;
        type = "lua";
        config = ''
          require("config.theme")
        '';
      }
      pkgs.vimPlugins.harpoon
      git-worktree-nvim
      nvim-notify
      nui-nvim
      noice-nvim
      pkgs.vimPlugins.indent-blankline-nvim
      lualine-nvim
      nvim-navic
      nvim-web-devicons

      {
        plugin = oil-nvim;
        type = "lua";
        config = ''
          require("oil").setup()
          vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
        '';
      }
      # {
      #   plugin = bufferline-nvim;
      #   type = "lua";
      #   config = ''
      #     require("config.theme")
      #   '';
      # }

      # {
      #   PLUGIN = nvim-colorizer-lua;
      #   type = "lua";
      #   config = ''
      #     require("colorizer").setup()
      #   '';
      # }
      # {
      #   plugin = dressing-nvim;
      #   type = "lua";
      #   config = ''
      #     require("dressing").setup()
      #   '';
      # }
      # popup-nvim
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
