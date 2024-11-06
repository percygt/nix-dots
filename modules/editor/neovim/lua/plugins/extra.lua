return {
  {
    "folke/zen-mode.nvim",
    event = "VeryLazy",
    opts = {
      window = {
        backdrop = 0.95,
        width = 80, -- width of the Zen window
        height = 1, -- height of the Zen window
        options = {
          signcolumn = "no", -- disable signcolumn
          number = false, -- disable number column
          relativenumber = false, -- disable relative numbers
          -- cursorline = false, -- disable cursorline
          -- cursorcolumn = false, -- disable cursor column
          -- foldcolumn = "0", -- disable fold column
          -- list = false, -- disable whitespace characters
        },
      },
      plugins = {
        -- disable some global vim options (vim.o...)
        options = {
          enabled = true,
          ruler = false, -- disables the ruler text in the cmd line area
          showcmd = false, -- disables the command in the last line of the screen
          -- you may turn on/off statusline in zen mode by setting 'laststatus'
          -- statusline will be shown only if 'laststatus' == 3
          laststatus = 0, -- turn off the statusline in zen mode
        },
        twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
        gitsigns = { enabled = false }, -- disables git signs
        tmux = { enabled = true }, -- disables the tmux statusline
        wezterm = {
          enabled = true,
          font = "+1", -- (10% increase per step)
        },
      },
    },
  },
  {
    "folke/twilight.nvim",
    event = "VeryLazy",
    lazy = true,
    keys = {
      { "<a-T>", "<cmd>Twilight<cr>", desc = "Twilight", silent = true },
    },
  },
  {
    "tzachar/local-highlight.nvim",
    event = "VeryLazy",
    config = function()
      require("local-highlight").setup({
        file_types = { "python", "cpp" }, -- If this is given only attach to this
        -- OR attach to every filetype except:
        disable_file_types = { "tex" },
        hlgroup = "Search",
        cw_hlgroup = nil,
        -- Whether to display highlights in INSERT mode or not
        insert_mode = false,
        min_match_len = 1,
        max_match_len = math.huge,
        highlight_single_match = true,
      })
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = true,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  { "brenoprata10/nvim-highlight-colors", event = "BufReadPost", opts = { render = "virtual" } },
  {
    "stevearc/dressing.nvim",
    opts = {
      input = {
        default_prompt = "> ",
        relative = "editor",
        prefer_width = 50,
        prompt_align = "center",
        win_options = { winblend = 0 },
      },
      select = {
        get_config = function(opts)
          opts = opts or {}
          local config = {
            telescope = {
              layout_config = {
                width = 0.8,
              },
            },
          }
          if opts.kind == "legendary.nvim" then
            config.telescope.sorter = require("telescope.sorters").fuzzy_with_index_bias({})
          end
          return config
        end,
      },
    },
  },
  {
    "max397574/better-escape.nvim",
    opts = {
      mappings = {
        v = {
          j = {
            k = false,
          },
        },
      },
    },
  },
  {
    "lukas-reineke/virt-column.nvim",
    opts = {
      char = { "│" },
      highlight = "LineNrNC",
    },
  },
  {
    "m4xshen/smartcolumn.nvim",
    event = "BufReadPost",
    opts = {
      colorcolumn = "100",
      { python = "120" },
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
    },
    event = { "BufNewFile", "BufReadPost" },
    config = function()
      local c = require("config.colorscheme")
      require("todo-comments").setup({
        keywords = {
          TODO = { icon = " ", color = c.base07 },
        },
      })
    end,
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    opts = {
      enable_autocmd = false,
    },
    config = function()
      local get_option = vim.filetype.get_option
      vim.filetype.get_option = function(filetype, option)
        return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
          or get_option(filetype, option)
      end
    end,
  },
  -- {
  --   "numToStr/Comment.nvim",
  --   dependencies = {
  --     "JoosepAlviste/nvim-ts-context-commentstring",
  --   },
  --   opts = function()
  --     require("Comment").setup({
  --       padding = true,
  --       ---Whether the cursor should stay at its position
  --       sticky = true,
  --       ---Lines to be ignored while (un)comment
  --       ---LHS of toggle mappings in NORMAL mode
  --       toggler = {
  --         ---Line-comment toggle keymap
  --         line = "gcc",
  --         ---Block-comment toggle keymap
  --         block = "gbc",
  --       },
  --       ---LHS of operator-pending mappings in NORMAL and VISUAL mode
  --       opleader = {
  --         ---Line-comment keymap
  --         line = "gc",
  --         ---Block-comment keymap
  --         block = "gb",
  --       },
  --       ---LHS of extra mappings
  --       extra = {
  --         ---Add comment on the line above
  --         above = "gcO",
  --         ---Add comment on the line below
  --         below = "gco",
  --         ---Add comment at the end of line
  --         eol = "gcA",
  --       },
  --       ---Enable keybindings
  --       ---NOTE: If given `false` then the plugin won't create any mappings
  --       mappings = {
  --         ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
  --         basic = true,
  --         ---Extra mapping; `gco`, `gcO`, `gcA`
  --         extra = true,
  --       },
  --       ---Function to call before (un)comment
  --       pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
  --       post_hook = nil,
  --       ignore = "^$",
  --     })
  --   end,
  -- },
  {
    "karb94/neoscroll.nvim",
    opts = {
      stop_eof = true,
      easing_function = "sine",
      hide_cursor = true,
      cursor_scrolls_alone = true,
      mappings = { -- Keys to be mapped to their corresponding default scrolling animation
        "<C-u>",
        "<C-d>",
        "<C-f>",
        "<C-y>",
        "zt",
        "zz",
        "zb",
      },
    },
  },
  {
    "danymat/neogen",
    opts = {
      snippet_engine = "luasnip",
    },
  },
  -- Lua
  {
    "szw/vim-maximizer",
    lazy = true,
    keys = {
      { "<c-w>z", "<cmd>MaximizerToggle<cr>", desc = "Window maximizer toggle", mode = { "n", "v" } },
    },
  },
  { "tpope/vim-repeat" },
}
