local colors = require("onedark.colors")
local hooks = require("ibl.hooks")

hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "IndentYellow", { fg = colors.yellow })
  vim.api.nvim_set_hl(0, "IndentBlack", { fg = colors.black })
end)

require("ibl").setup({
  scope = {
    enabled = true,
    char = "▏",
    highlight = "IndentYellow",
  },
  indent = {
    char = "▏",
    smart_indent_cap = true,
    highlight = "IndentBlack",
  },
})
