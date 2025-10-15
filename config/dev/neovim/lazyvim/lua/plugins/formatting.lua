return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    local prettier = { "prettierd", "prettier", stop_after_first = true }
    opts.formatters = {
      ["markdownlint-cli2"] = {
        condition = function(_, ctx)
          local diag = vim.tbl_filter(function(d)
            return d.source == "markdownlint"
          end, vim.diagnostic.get(ctx.buf))
          return #diag > 0
        end,
      },
    }
    opts.formatters_by_ft = {
      nix = { "nixfmt" },
      javascript = { "deno_fmt" },
      typescript = { "deno_fmt" },
      javascriptreact = { "deno_fmt" },
      typescriptreact = { "deno_fmt" },
      json = { "deno_fmt" },
      jsonc = { "deno_fmt" },
      -- kdl = { "kdlfmt" },
      markdown = { "deno_fmt", "markdownlint-cli2" },
      ["markdown.mdx"] = { "deno_fmt", "markdownlint-cli2" },
      -- ["astro"] = { "prettier" },
      vue = prettier,
      css = prettier,
      scss = prettier,
      less = prettier,
      html = prettier,
      yaml = prettier,
      mdx = prettier,
      graphql = prettier,
      lua = { "stylua" },
      go = { "goimports", "gofmt" },
      sh = { "shfmt" },
      python = { "ruff_format", "ruff_fix" },
      ["_"] = { "trim_whitespace", "trim_newlines" },
    }
  end,
}
