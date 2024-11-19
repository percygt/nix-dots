return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      "nvim-telescope/telescope.nvim", -- optional
    },
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Neogit Commit" },
      { "<leader>gp", "<cmd>Neogit push<cr>", desc = "Neogit Push" },
      { "<leader>gP", "<cmd>Neogit pull<cr>", desc = "Neogit Pull" },
      { "<leader>gd", "<cmd>Neogit diff<cr>", desc = "Neogit Diff" },
    },
    opts = {
      integrations = {
        diffview = true,
        telescope = true,
      },
      disable_prompt_on_change = true,
      commit_select_view = {
        kind = "floating",
      },
      commit_view = {
        kind = "floating",
      },
      signs = {
        item = { " ", " " },
        section = { " ", " " },
      },
      log_view = {
        kind = "floating",
      },
      reflog_view = {
        kind = "floating",
      },
    },
  },

  { "akinsho/git-conflict.nvim", version = "*", config = true },
  {
    "lewis6991/gitsigns.nvim",
    -- stylua: ignore
    keys = {
			{ "<leader>g", "", desc = "+Git", mode = { "n", "v" } },
			{ "<leader>go", "<cmd>Telescope git_status<cr>", desc = "Git status" },
			{ "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branches" },
			-- { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Checkout commits" },
			{ "<leader>gG", "<cmd>Telescope git_bcommits<cr>", desc = "Checkout commits(for current buffer)" },
    },
    opts = {
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end
        -- stylua: ignore start
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
        map("n", "<leader>gk", "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", "Prev Hunk")
        map("n", "<leader>gj", "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", "Next Hunk")
        map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>gu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>gR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>gh", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>gl", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>gL", function() gs.blame() end, "Blame Buffer")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
  },
}
