local opts = {
  linters_by_ft = {
    lua = { "luacheck" },
    python = { "ruff" },
    nix = { "statix" },
    sh = { "shellcheck" },
    yaml = { "yamllint" },
    cpp = { "cppcheck" },
    go = { "golangcilint" },
  },
  linters = {
    "actionlint",
    "eslint_d",
  },
}

local uv = vim.uv or vim.loop
local lint = require("lint")
lint.linters_by_ft = opts.linters_by_ft
for k, v in pairs(opts.linters) do
  lint.linters[k] = v
end
local timer = assert(uv.new_timer())
local DEBOUNCE_MS = 500
local aug = vim.api.nvim_create_augroup("Lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged", "InsertLeave" }, {
  group = aug,
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    timer:stop()
    timer:start(
      DEBOUNCE_MS,
      0,
      vim.schedule_wrap(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          vim.api.nvim_buf_call(bufnr, function()
            lint.try_lint(nil, { ignore_errors = true })
          end)
        end
      end)
    )
  end,
})
lint.try_lint(nil, { ignore_errors = true })
