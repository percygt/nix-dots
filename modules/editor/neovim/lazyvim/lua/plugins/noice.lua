return {
  {
    "folke/noice.nvim",
    keys = {
      { "<c-b>", false },
    },
    opts = function(_, opts)
      opts.cmdline = {
        view = "cmdline",
        format = {
          search_down = {
            view = "cmdline",
          },
          search_up = {
            view = "cmdline",
          },
        },
      }
      opts.lsp = {
        signature = {
          auto_open = {
            trigger = false,
          },
        },
        hover = {
          enabled = false,
        },
      }
      opts.views = {
        split = {
          enter = true,
          position = "right",
          size = "60%",
        },
      }
      opts.presets.inc_rename = false -- enables an input dialog for inc-rename.nvim
      opts.presets.lsp_doc_border = true -- add a border to hover docs and signature help
      return opts
    end,
  },
}
