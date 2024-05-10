require("gitsigns").setup({
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "󰍵" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "│" },
  },
  current_line_blame = false,
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]h", function()
      if vim.wo.diff then
        return "]h"
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })

    map("n", "[h", function()
      if vim.wo.diff then
        return "[h"
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })

    --Git Worktree
    map(
      "n",
      "<leader>gl",
      "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<cr>",
      { desc = "Worktree list" }
    )
    map(
      "n",
      "<leader>gc",
      "<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>",
      { desc = "Create worktree" }
    )

    -- Actions
    map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
    map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", { desc = "Stage hunk" })
    map("n", "<leader>ghS", gs.stage_buffer, { desc = "Stage buffer" })
    map("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
    map("n", "<leader>ghR", gs.reset_buffer, { desc = "Reset buffer" })
    map("n", "<leader>ghp", gs.preview_hunk, { desc = "Preview hunk" })
    map("n", "<leader>ghb", function()
      gs.blame_line({ full = true })
    end, { desc = "Blame line" })
    map("n", "<leader>ghd", gs.diffthis, { desc = "Diff this" })
    map("n", "<leader>ghD", function()
      gs.diffthis("~")
    end, { desc = "Diff this ~" })
    -- Text object
    map({ "o", "x" }, "gh", ":<C-U>Gitsigns select_hunk<CR>", { desc = "GitSigns select hunk" })
  end,
})
