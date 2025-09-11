return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = "all",
      ignore_install = { "org" },
      indent = {
        enable = true,
        disable = { "python", "yaml", "org" }, -- Yaml and Python indents are unusable
      },
    },
  },
  -- -- Playground treesitter utility
  {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle",
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = function(_, opts)
      local new_opts = {
        enable = false,
        max_lines = 5,
        trim_scope = "outer",
        zindex = 40,
        mode = "cursor",
        separator = nil,
      }
      for key, value in pairs(new_opts) do
        opts[key] = value
      end
      return opts
    end,
  },
}
