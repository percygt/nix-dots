local private = require("config.private")
return {
  jsonls = {},
  terraformls = {
    cmd = { "terraform-ls" },
    arg = { "server" },
    filetypes = { "terraform", "tf", "terraform-vars" },
  },
  pylsp = {},
  neocmake = {},
  clojure_lsp = {},
  clangd = {},
  nushell = {},
  nil_ls = {
    settings = {
      ["nil"] = {
        nix = {
          flake = {
            autoArchive = false,
          },
        },
      },
    },
  },
  nixd = {
    cmd = { "nixd" },
    settings = {
      nixd = {
        nixpkgs = {
          expr = [[import (builtins.getFlake "]] .. private.flakeDirectory .. [[").inputs.nixpkgs { }   ]],
        },
        formatting = {
          command = { "nixfmt" },
        },
        options = {
          nixos = {
            expr = [[(builtins.getFlake "]]
              .. private.flakeDirectory
              .. [[").nixosConfigurations."]]
              .. private.profile
              .. [[".options]],
          },
          home_manager = {
            expr = [[(builtins.getFlake "]]
              .. private.flakeDirectory
              .. [[").homeConfigurations."]]
              .. private.username
              .. "@"
              .. private.profile
              .. [[".options]],
          },
        },
      },
    },
    on_init = function(client, _)
      client.server_capabilities.semanticTokensProvider = nil
    end,
  },
  volar = {
    init_options = {
      vue = {
        hybridMode = true,
      },
    },
  },
  svelte = {},
  dockerls = {},
  bashls = {
    filetypes = { "sh" },
  },
  vimls = {
    filetypes = { "vim" },
  },
  denols = {
    root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc"),
  },
  vtsls = {},
  astro = {},
  yamlls = {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml" },
  },
  zls = {},
  gopls = {},
  marksman = {},
  taplo = {},
  cssls = {},
  lua_ls = {
    init_options = {
      documentFormatting = false,
    },
  },
}
