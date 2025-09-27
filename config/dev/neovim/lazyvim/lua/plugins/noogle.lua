return {
  "fredrikaverpil/godoc.nvim",
  dependencies = {
    {
      "juliamertz/noogle-cli",
      -- optionally build from source, this is only necessary if you don't have noogle in your PATH
      build = "nix build .#noogle-nvim && cp -vrTL result/lua lua",
    },
  },
  opts = {
    adapters = {
      {
        setup = function()
          return require("noogle").setup()
        end,
      },
    },
  },
}
