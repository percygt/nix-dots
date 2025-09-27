return {
  "mfussenegger/nvim-lint",
  opts = function(_, opts)
    opts.linters_by_ft = {
      nix = { "statix" },
      sh = { "shellcheck" },
      yaml = { "yamllint" },
      cpp = { "cppcheck" },
      cmake = { "cmakelint" },
      dockerfile = { "hadolint" },
      go = { "golangcilint" },
    }
    opts.linters = {
      "actionlint",
      "eslint_d",
    }
  end,
}
