return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = function()
      vim.cmd("TSUpdate")
    end,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
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
        ensure_installed = {
          "html",
          "htmldjango",
          "rust",
          "go",
          "c",
          "astro",
          "clojure",
          "latex",
          "css",
          "scss",
          "bash",
          "fish",
          "json",
          "lua",
          "markdown",
          "nix",
          "python",
          "rust",
          "toml",
          "vim",
          "regex",
          "jsonc",
          "markdown_inline",
          "yaml",
          "javascript",
          "tmux",
          "tsx",
          "php",
          "ini",
        },
        indent = {
          enable = true,
          disable = { "python", "yaml" }, -- Yaml and Python indents are unusable
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
    cmd = { "TSContextToggle" },
    keys = { { "<leader>tt", "<cmd>TSContextToggle<cr>", desc = "Toggle treesitter context" } },
    opts = {
      enable = false,
      max_lines = 5,
      trim_scope = "outer",
      zindex = 40,
      mode = "cursor",
      separator = nil,
    },
  },
  -- -- Playground treesitter utility
  {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle",
  },
}
