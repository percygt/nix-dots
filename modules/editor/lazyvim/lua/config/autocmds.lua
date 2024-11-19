-- don't auto comment new line
vim.api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })
-- -- go to last loc when opening a buffer
-- -- this mean that when you open a file, you will be at the last position
-- vim.api.nvim_create_autocmd("BufReadPost", {
--   callback = function()
--     local mark = vim.api.nvim_buf_get_mark(0, '"')
--     local lcount = vim.api.nvim_buf_line_count(0)
--     if mark[1] > 0 and mark[1] <= lcount then
--       pcall(vim.api.nvim_win_set_cursor, 0, mark)
--     end
--   end,
-- })
-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
  group = vim.api.nvim_create_augroup("Highlight", { clear = true }),
})

-- Enable spell checking for certain file types
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.txt", "*.md", "*.tex" },
  callback = function()
    vim.opt.spell = true
    vim.opt.spelllang = "en"
  end,
})
-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})
vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    vim.notify("This buffer has been saved successfully!", 2)
  end,
})
