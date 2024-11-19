return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        require("catppuccin").load()
      end,
      defaults = {
        keymaps = false,
      },
      icons = {
        kinds = require("config.icons").kind,
        diagnostics = require("config.icons").diagnostics,
        git = require("config.icons").git,
      },
    },
  },
  {
    "folke/snacks.nvim",
    keys = function()
      return {
        {
          "<leader><leader>",
          function()
            Snacks.notifier.hide()
          end,
          desc = "Dismiss All Notifications",
        },
        {
          "D",
          function()
            Snacks.bufdelete()
          end,
          desc = "Delete Buffer",
        },
        {
          "<leader>gB",
          function()
            Snacks.gitbrowse()
          end,
          desc = "Git Browse",
        },
        {
          "<leader>R",
          function()
            Snacks.rename()
          end,
          desc = "Rename File",
        },
        {
          "]]",
          function()
            Snacks.words.jump(vim.v.count1)
          end,
          desc = "Next Reference",
          mode = { "n", "t" },
        },
        {
          "[[",
          function()
            Snacks.words.jump(-vim.v.count1)
          end,
          desc = "Prev Reference",
          mode = { "n", "t" },
        },
        -- {
        --   "<leader>N",
        --   desc = "Neovim News",
        --   function()
        --     Snacks.win({
        --       file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
        --       width = 0.75,
        --       height = 0.75,
        --       wo = {
        --         spell = false,
        --         wrap = false,
        --         signcolumn = "yes",
        --         statuscolumn = " ",
        --         conceallevel = 3,
        --       },
        --     })
        --   end,
        -- },
      }
    end,
  },
}
