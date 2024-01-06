{pkgs, ...}: {
  clangd = {};
  nil_ls = {};
  ruff_lsp = {};
  pyright = {};
  dockerls = {};
  bashls = {};
  terraformls = {};
  gopls = {};
  tsserver = {
    init_options.tsserver.path = "${pkgs.nodePackages.typescript}/bin/tsserver";
    documentFormatting = false;
    hostInfo = "neovim";
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
