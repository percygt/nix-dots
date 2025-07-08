return {
  -- {
  --   "mg979/vim-visual-multi",
  --   -- See https://github.com/mg979/vim-visual-multi/issues/241
  --   init = function()
  --     vim.g.VM_default_mappings = 0
  --     vim.g.VM_maps = {
  --       ["Find Under"] = "",
  --     }
  --     vim.g.VM_add_cursor_at_pos_no_mappings = 1
  --   end,
  --   keys = {
  --     { "<leader>nn", "<Plug>(VM-Find-Under)<Tab>", desc = "Start multi cusors", mode = { "n", "v" } },
  --     { "<leader>na", "<Plug>(VM-Select-All)<Tab>", desc = "Select All", mode = { "n" } },
  --     { "<leader>nr", "<Plug>(VM-Start-Regex-Search)", desc = "Start Regex Search", mode = { "n" } },
  --     { "<leader>np", "<Plug>(VM-Add-Cursor-At-Pos)", desc = "Add Cursor At Pos", mode = { "n", "v" } },
  --     { "<leader>nd", "<Plug>(VM-Add-Cursor-Down)", desc = "Add Cursor Down", mode = { "n", "v" } },
  --     { "<leader>no", "<Plug>(VM-Toggle-Mappings)", desc = "Toggle Mapping", mode = { "n" } },
  --   },
  -- },
  {
    "smoka7/multicursors.nvim",
    -- enabled = false,
    event = "VeryLazy",
    dependencies = {
      -- FIX: https://github.com/nvimtools/hydra.nvim/pull/47
      -- "nvimtools/hydra.nvim",
      "Cathyprime/hydra.nvim",
    },
    cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
    opts = {
      hint_config = {
        float_opts = {
          border = "rounded",
        },
        position = "bottom-right",
      },
      generate_hints = {
        normal = true,
        insert = true,
        extend = true,
        config = {
          column_count = 1,
        },
      },
    },
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
