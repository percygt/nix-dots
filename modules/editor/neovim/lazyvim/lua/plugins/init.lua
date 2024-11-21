return {
  {
    "LazyVim/LazyVim",
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimKeymaps",
        once = true,
        callback = function()
          pcall(vim.keymap.del, "n", "<leader>-")
          pcall(vim.keymap.del, "n", "<leader>|")
          pcall(vim.keymap.del, "n", "<leader>K")
          pcall(vim.keymap.del, "n", "<leader>qq")
          pcall(vim.keymap.del, "n", "<leader><tab>l")
          pcall(vim.keymap.del, "n", "<leader><tab>o")
          pcall(vim.keymap.del, "n", "<leader><tab>f")
          pcall(vim.keymap.del, "n", "<leader><tab><tab>")
          pcall(vim.keymap.del, "n", "<leader><tab>]")
          pcall(vim.keymap.del, "n", "<leader><tab>d")
          pcall(vim.keymap.del, "n", "<leader><tab>[")
        end,
      })
    end,
    opts = {
      colorscheme = function()
        require("catppuccin").load()
      end,
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
        -- {
        --   "<leader>R",
        --   function()
        --     Snacks.rename()
        --   end,
        --   desc = "Rename File",
        -- },
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
      }
    end,
  },
}
