return {
  "folke/snacks.nvim",
       -- stylua: ignore
    keys = {
      { "<leader>.", false },
      { "<leader>S", false },
      { "<leader>n", false },
      { "<leader>S", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>`s", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      { "<leader>`n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "D", function() Snacks.bufdelete() end, desc = "Delete Buffer", },
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    },
}
