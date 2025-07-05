-- don't auto comment new line
vim.api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })
vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    vim.notify("Saved!", 2)
  end,
})
