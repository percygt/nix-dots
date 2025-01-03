local org_dir = require("config.private").orgDirectory
return {
  {
    "chipsenkbeil/org-roam.nvim",
    enabled = false,
    event = "VeryLazy",
    ft = { "org" },
    dependencies = {
      "nvim-orgmode/orgmode",
    },
    config = function()
      require("org-roam").setup({
        directory = org_dir,
        database = {
          path = org_dir .. "/resources/nvim-org-roam.db",
        },
      })
    end,
  },
  {
    "akinsho/org-bullets.nvim",
    enabled = false,
    event = "VeryLazy",
    ft = { "org" },
    config = function()
      require("org-bullets").setup()
    end,
  },
  -- {
  --   "lukas-reineke/headlines.nvim",
  --   dependencies = "nvim-treesitter/nvim-treesitter",
  --   config = true, -- or `opts = {}`
  -- },
  {
    "nvim-orgmode/orgmode",
    enabled = false,
    event = "VeryLazy",
    dependencies = { "dhruvasagar/vim-table-mode", "nvim-orgmode/orgmode" },
    ft = { "org" },
    init = function()
      vim.opt.conceallevel = 2
      vim.opt.concealcursor = "nc"
      vim.g.completion_chain_complete_list = {
        org = {
          { mode = "omni" },
        },
      }
      -- add additional keyword chars
      vim.cmd([[autocmd FileType org setlocal iskeyword+=:,#,+]])
    end,
    config = function()
      -- Setup orgmode
      require("orgmode").setup({
        org_agenda_files = org_dir .. "/**/*",
        mappings = {
          global = {
            org_agenda = { "<Leader>oa" },
            org_capture = { "<Leader>oc" },
          },
        },
      })
      -- local cmp = require("cmp")
      -- local config = cmp.get_config()
      -- table.insert(config.sources, { name = "orgmode" })
      -- return cmp.setup(config)
    end,
  },
}
