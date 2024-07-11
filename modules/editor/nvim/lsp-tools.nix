{pkgs, ...}: {
  null_ls = {
    ## Built-in sources
    ## https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
    ##
    ## Built-in configurations for source that can be used:
    ## [formatting, diagnostics, code_actions]
    ## https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md
    ##
    ## Option for built-in configurations that can be used:
    ## [filetypes, extra_filetypes, args, extra_args, disabled_filetypes, condition.root_has_file]
    ## https://github.com/nvimtools/none-ls.nvim/blob/main/doc/CONFIG.md

    formatting = {
      # ruff_format = {};
      shfmt = {};
      clang_format = {};
      shellharden = {};
      alejandra = {}; # [nix]
      stylua = {};
      taplo = {}; # [toml]
      prettierd = {
        filetypes = [
          "css"
          "scss"
          "less"
          "html"
          "yaml"
          "graphql"
          "vue"
          "markdown"
          "mdx"
        ];
        # extra_filetypes = ["astro"];
      };
      prettier = {
        filetypes = [
          "astro"
        ];
        extra_args = [
          "--plugin"
          "${pkgs.nodePackages-extra.prettier-plugin-astro}/lib/node_modules/prettier-plugin-astro/dist/index.js"
        ];
      };
      deno_fmt = {
        filetypes = [
          "javascript"
          "javascriptreact"
          "json"
          "jsonc"
          "markdown"
          "typescript"
          "typescriptreact"
        ];
      };
    };

    diagnostics = {
      # ruff = {};
      yamllint = {};
      # markdownlint = {};
      cppcheck = {};
      golangci_lint = {};
      statix = {}; # [nix]
      actionlint = {};
      eslint_d = {
        # condition.root_has_file = [".eslintrc.js" ".eslintrc.cjs"];
      };
    };

    code_actions = {
      eslint_d = {
        # condition.root_has_file = [".eslintrc.js" ".eslintrc.cjs"];
      };
      shellcheck = {};
      statix = {};
      gitsigns = {};
    };
  };
  conform = {};
}
