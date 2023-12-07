{pkgs, ...}: {
  programs.neovim = let
    toLua = str: "lua << EOF\n${str}\nEOF\n";
  in {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [
      lua-language-server
      rnix-lsp

      xclip
      wl-clipboard
    ];

    plugins = with pkgs.vimPlugins; [
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = builtins.readFile ../common/nvim/plugin/lsp.lua;
      }

      {
        plugin = comment-nvim;
        config = toLua "require(\"Comment\").setup()";
      }

      {
        plugin = gruvbox-nvim;
        config = "colorscheme gruvbox";
      }

      neodev-nvim

      nvim-cmp
      {
        plugin = nvim-cmp;
        type = "lua";
        config = builtins.readFile ../common/nvim/plugin/cmp.lua;
      }

      {
        plugin = telescope-nvim;
        type = "lua";
        config = builtins.readFile ../common/nvim/plugin/telescope.lua;
      }

      telescope-fzf-native-nvim

      cmp_luasnip
      cmp-nvim-lsp

      luasnip
      friendly-snippets

      lualine-nvim
      nvim-web-devicons

      {
        plugin = nvim-treesitter.withPlugins (p: [
          p.tree-sitter-nix
          p.tree-sitter-vim
          p.tree-sitter-bash
          p.tree-sitter-lua
          p.tree-sitter-python
          p.tree-sitter-json
        ]);
        type = "lua";
        config = builtins.readFile ../common/nvim/plugin/treesitter.lua;
      }

      vim-nix

      # {
      #   plugin = vimPlugins.own-onedark-nvim;
      #   config = "colorscheme onedark";
      # }
    ];

    extraLuaConfig = ''
      ${builtins.readFile ../common/nvim/options.lua}
    '';

    # extraLuaConfig = ''
    #   ${builtins.readFile ../common/nvim/options.lua}
    #   ${builtins.readFile ../common/nvim/plugin/lsp.lua}
    #   ${builtins.readFile ../common/nvim/plugin/cmp.lua}
    #   ${builtins.readFile ../common/nvim/plugin/telescope.lua}
    #   ${builtins.readFile ../common/nvim/plugin/treesitter.lua}
    #   ${builtins.readFile ../common/nvim/plugin/other.lua}
    # '';
  };
}
