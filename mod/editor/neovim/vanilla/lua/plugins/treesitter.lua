return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = function()
      vim.cmd("TSUpdate")
    end,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      { "nushell/tree-sitter-nu", build = ":TSUpdate nu" },
    },
    keys = {
      { "<leader>ti", "<cmd>Inspect<cr>", desc = "Show highlighting groups and captures" },
    },
    config = function()
      if vim.gcc_bin_path ~= nil then
        require("nvim-treesitter.install").compilers = { vim.g.gcc_bin_path }
      end
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
        sync_install = false,
        -- ignore_install = { "javascript" },
        auto_install = true,
        ensure_installed = "all",
        ignore_install = { "org" },
        indent = {
          enable = true,
          disable = { "python", "yaml", "org" }, -- Yaml and Python indents are unusable
        },
        highlight = {
          enable = true,
          disable = { "yaml" },
          additional_vim_regex_highlighting = false,
        },
        -- autopairs = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<leader>hv",
            node_incremental = "+",
            scope_incremental = false,
            node_decremental = "_",
          },
        },
        textobjects = {
          select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["ai"] = "@conditional.outer",
              ["ii"] = "@conditional.inner",
              ["il"] = "@loop.inner",
              ["al"] = "@loop.outer",
              ["ak"] = "@block.outer",
              ["ik"] = "@block.inner",
              ["is"] = "@statement.inner",
              ["as"] = "@statement.outer",
              ["am"] = "@call.outer",
              ["im"] = "@call.inner",
              ["at"] = "@comment.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["(a"] = "@parameter.inner",
            },
            swap_previous = {
              ["(A"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
        },
      })
    end,
  },
  -- -- Show sticky context for off-screen scope beginnings
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufRead",
    -- keys = { { "<leader>tt", "<cmd>TSContextToggle<cr>", desc = "Toggle treesitter context" } },
    opts = function()
      local tsc = require("treesitter-context")
      Snacks.toggle({
        name = "Treesitter Context",
        get = tsc.enabled,
        set = function(state)
          if state then
            tsc.enable()
          else
            tsc.disable()
          end
        end,
      }):map("<leader>ut")
      return {
        enable = false,
        max_lines = 5,
        trim_scope = "outer",
        zindex = 40,
        mode = "cursor",
        separator = nil,
      }
    end,
  },
  -- -- Playground treesitter utility
  {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle",
  },
  -- Automatically add closing tags for HTML and JSX
  {
    "windwp/nvim-ts-autotag",
    event = "BufRead",
    opts = {},
  },
}
