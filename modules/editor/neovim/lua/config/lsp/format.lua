local prettier = { "prettierd", "prettier" }
require("conform").setup({
  formatters_by_ft = {
    nix = { "alejandra" },
    javascript = { "deno_fmt" },
    typescript = { "deno_fmt" },
    javascriptreact = { "deno_fmt" },
    typescriptreact = { "deno_fmt" },
    json = { "deno_fmt" },
    jsonc = { "deno_fmt" },
    markdown = { "deno_fmt" },
    astro = { prettier },
    vue = { prettier },
    css = { prettier },
    scss = { prettier },
    less = { prettier },
    html = { prettier },
    yaml = { prettier },
    mdx = { prettier },
    graphql = { prettier },
    lua = { "stylua" },
    go = { "goimports", "gofmt" },
    sh = { "shfmt" },
    python = { "ruff_format", "ruff_fix" },
    ["_"] = { "trim_whitespace", "trim_newlines" },
  },
  log_level = vim.log.levels.TRACE,
  format_on_save = function(bufnr)
    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 5000, lsp_fallback = true }
  end,
})
