return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      "kristijanhusak/vim-dadbod-completion",
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    keys = {
      { "<leader>S", "", desc = "+Database", mode = { "n", "v" } },
      { "<leader>St", "<cmd>DBUIToggle<cr>", desc = "Toggle UI" },
      { "<leader>Sf", "<cmd>DBUIFindBuffer<cr>", desc = "Find buffer" },
      { "<leader>Sr", "<cmd>DBUIRenameBuffer<cr>", desc = "Rename buffer" },
      { "<leader>Sq", "<cmd>DBUILastQueryInfo<cr>", desc = "Last query info" },
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  { "kkharji/sqlite.lua" },
}
