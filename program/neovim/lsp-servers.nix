{pkgs, ...}: {
  # ruff_lsp = {};
  # pyright = {};
  pylsp = {
    plugins = {
      ruff = {
        enabled = true;
        extendSelect = ["I"];
      };
      pylsp_mypy = {enabled = true;};
      jedi_completion = {fuzzy = true;};
      black = {enabled = false;};
      pyls_isort = {enabled = false;};
      autopep8 = {enabled = false;};
      yapf = {enabled = false;};
      pylint = {enabled = false;};
      pyflakes = {enabled = false;};
      pycodestyle = {enabled = false;};
    };
  };
  clangd = {};
  nil_ls = {};
  dockerls = {};
  bashls = {};
  terraformls = {};
  gopls = {};
  marksman = {};
  denols = {
    root_pattern = ["deno.json" "deno.jsonc"];
  };
  tsserver = {
    init_options.tsserver.path = "${pkgs.nodePackages.typescript}/bin/tsserver";
    documentFormatting = false;
    single_file_support = false;
    hostInfo = "neovim";
    root_pattern = ["package.json"];
  };
  astro = {
    init_options.typescript.tsdk = "${pkgs.nodePackages.typescript}/lib/node_modules/typescript/lib/";
  };
  taplo = {};
  cssls = {};
  # eslint = {settings.format = false;};
  jsonls = {init_options.provideFormatter = false;};
  html = {init_options.provideFormatter = false;};
  lua_ls = {
    init_options.documentFormatting = false;
    settings.Lua = {
      runtime.version = "LuaJIT";
      format = {
        enable = false;
        defaultConfig = {
          indent_style = "space";
          indent_size = "2";
          quote_style = "AutoPreferDouble";
          call_parentheses = "Always";
          column_width = "120";
          line_endings = "Unix";
        };
      };
      diagnostics = {
        enable = true;
        globals = ["vim" "hs"];
      };
      workspace.library = {
        checkThirdParty = false;
      };
      telemetry.enable = false;
    };
  };
}
