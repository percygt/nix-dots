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
  };
  astro = {
    init_options.typescript.tsdk = "${pkgs.nodePackages.typescript}/lib/node_modules/typescript/lib/";
  };
  taplo = {};
  cssls = {};
  eslint = {settings.format = false;};
  jsonls = {init_options.provideFormatter = false;};
  html = {init_options.provideFormatter = false;};
  lua_ls = {
    settings.Lua = {
      runtime.version = "LuaJIT";
      diagnostics = {
        enable = false;
        globals = ["vim"];
      };
      workspace.library = {};
      telemetry.enable = false;
    };
  };
}
