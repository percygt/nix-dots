return {
  {
    "chipsenkbeil/org-roam.nvim",
    enabled = false,
    dependencies = {
      "nvim-orgmode/orgmode",
    },
    config = function()
      require("org-roam").setup({
        directory = "~/data/notes/journals",
      })
    end,
  },
  {
    "akinsho/org-bullets.nvim",
    enabled = false,
    dependencies = { "nvim-orgmode/orgmode" },
    config = function()
      require("org-bullets").setup()
    end,
  },
  {
    "nvim-orgmode/orgmode",
    enabled = false,
    event = "VeryLazy",
    dependencies = { "dhruvasagar/vim-table-mode" },
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
        org_agenda_files = "~/data/notes/**/*",
        -- mappings = {
        --   global = {
        --     org_agenda = { "oA", "<Leader>Oa" },
        --     org_capture = { "oC", "<Leader>Oc" },
        --   },
        -- },
      })

      local cmp = require("cmp")
      local config = cmp.get_config()
      table.insert(config.sources, { name = "orgmode" })
      return cmp.setup(config)
    end,
  },
}
