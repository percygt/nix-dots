-- Don't auto comment new line
vim.api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

-- Saved notif
vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    vim.notify("Saved!", 2)
  end,
})

-- Disable CSS diagnostics if in flakeDirectory
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.css",
  group = vim.api.nvim_create_augroup("__flakeCss", { clear = true }),
  callback = function(args)
    local buf_path = vim.api.nvim_buf_get_name(0)
    if buf_path:find(require("config.system").flakeDirectory, 1, true) == 1 then
      vim.diagnostic.enable(false, { bufnr = args.buf })
    end
  end,
})
