return {
  {
    "smoka7/multicursors.nvim",
    enabled = false,
    event = "VeryLazy",
    dependencies = {
      "nvimtools/hydra.nvim",
    },
    opts = {
      hint_config = false,
    },
    cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
   -- stylua: ignore
  keys = {
  	{ "<leader>nn", "<cmd>MCstart<cr>", desc = "MCstart", mode = { "n", "v" } },
  	{ "<leader>nv", "<cmd>MCvisual<cr>", desc = "MCvisual", mode = { "n", "v" } },
  	{ "<leader>nc", "<cmd>MCclear<cr>", desc = "MCclear", mode = { "n", "v" } },
  	{ "<leader>np", "<cmd>MCpattern<cr>", desc = "MCpattern", mode = { "n", "v" } },
  	{ "<leader>nV", "<cmd>MCvisualPattern<cr>", desc = "MCvisualPattern", mode = { "n", "v" } },
  	{ "<leader>nu", "<cmd>MCunderCursor<cr>", desc = "MCunderCursor", mode = { "n", "v" } },
  },
  },
}
