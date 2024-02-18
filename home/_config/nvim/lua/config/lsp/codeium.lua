-- vim.g.codeium_disable_bindings = 1
-- local keymap = require("config.helpers")
-- local inoremap = keymap.inoremap

require("codeium").setup()

-- inoremap("<a-g>", function()
--   return vim.fn["codeium#Accept"]()
-- end, { expr = true, desc = "Codeium Accept" })
-- inoremap("<a-[>", function()
--   return vim.fn["codeium#CycleCompletions"](1)
-- end, { expr = true, desc = "Codeium Next Suggestion" })
-- inoremap("<a-]>", function()
--   return vim.fn["codeium#CycleCompletions"](-1)
-- end, { expr = true, desc = "Codeium Prev Sugestion" })
-- inoremap("<a-c>", function()
--   return vim.fn["codeium#Clear"]()
-- end, { expr = true, desc = "Codeium clear suggestion" })
