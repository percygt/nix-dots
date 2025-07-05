return {
  -- {
  --   "rcarriga/nvim-notify",
  --   event = "VeryLazy",
  --   opts = {
  --     background_colour = "#000000",
  --     enabled = false,
  --   },
  -- },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader><leader>", "<cmd>NoiceDismiss<cr>", desc = "Noice Dismiss" },
      {
        "<leader>sn",
        function()
          require("noice").cmd("pick")
        end,
        desc = "Noice Picker (Telescope)",
      },
    },
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == "lazy" then
        vim.cmd([[messages clear]])
      end
      require("noice").setup(opts)
    end,
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      cmdline = {
        view = "cmdline",
        format = {
          search_down = {
            view = "cmdline",
          },
          search_up = {
            view = "cmdline",
          },
        },
      },
      presets = {
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
      views = {
        split = {
          enter = true,
          position = "right",
          size = "60%",
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
              { find = "%d fewer lines" },
              { find = "%d more lines" },
            },
          },
          opts = { skip = true },
        },
      },
    },
  },
}
