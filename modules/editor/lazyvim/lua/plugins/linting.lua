return {
  "mfussenegger/nvim-lint",
  opts = function(_, opts)
    table.insert(opts.linters_by_ft, {
      lua = { "luacheck" },
      python = { "ruff" },
      nix = { "statix" },
      sh = { "shellcheck" },
      yaml = { "yamllint" },
      cpp = { "cppcheck" },
      go = { "golangcilint" },
    })
    table.insert(opts.linters, {
      "actionlint",
      "eslint_d",
    })
  end,
}
