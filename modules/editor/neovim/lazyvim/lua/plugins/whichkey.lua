-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/editor.lua#L173
return {
  {
    "folke/which-key.nvim",
    opts = {
      win = {
        border = "single",
      },
      layout = {
        align = "center",
      },
      triggers = {
        { "<auto>", mode = "xso" },
        { "g", mode = { "n" } },
        { "z", mode = { "n" } },
        { "<leader>", mode = { "n", "v" } },
        { "<c-w>", mode = { "n", "v" } },
        { "<localleader>", mode = { "n", "v" } },
      },
      icons = {},
      spec = {
        { "W", hidden = true },
        { "Q", hidden = true },
        { "<leader>,", icon = "" },
        { "<leader>.", icon = "" },
        { "<leader>f", icon = "" },
        { "<leader>F", icon = "" },
        { "<leader>p", [["_dP]], mode = "x" },
        { "<leader>`", group = "Helper", icon = "" },
        { "<leader>n", group = "Multicursor", icon = "" },
        -- { "<leader>o", group = "Org", icon = "" },
        { "<leader>c", group = "Code" },
        { "<leader>g", group = "Git" },
        { "<leader>s", group = "Search" },
        { "<leader>d", group = "Debug" },
        { "<leader>t", group = "Test" },
        { "<leader>u", group = "UI", icon = { icon = "󰙵 ", color = "cyan" } },
        { "<leader>x", group = "Diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
        { "<leader><tab>", group = "Sessions", icon = "" },
        {
          "<leader>`r",
          ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
          mode = { "n", "v" },
          desc = "Multi Replace",
        },
        { "<leader>`x", "<cmd>!chmod +x %<cr>", desc = "Make executable" },
        {
          "<leader>b",
          group = "Buffer",
          expand = function()
            return require("which-key.extras").expand.buf()
          end,
        },
        {
          "<leader>w",
          group = "Windows",
          proxy = "<c-w>",
          expand = function()
            return require("which-key.extras").expand.win()
          end,
        },
        { "<leader>/", hidden = true },
        { "<leader>?", hidden = true },
        { "<leader>Y", hidden = true },
        { "<leader>y", hidden = true },
        { "<leader>p", hidden = true },
      },
    },
  },
}
