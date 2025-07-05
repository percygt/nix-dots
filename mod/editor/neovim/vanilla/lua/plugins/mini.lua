return {
  -- Better text-objects
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    version = false,
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          -- i = LazyVim.mini.ai_indent, -- indent
          -- g = LazyVim.mini.ai_buffer, -- buffer
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      -- LazyVim.on_load("which-key.nvim", function()
      --   vim.schedule(function()
      --     LazyVim.mini.ai_whichkey(opts)
      --   end)
      -- end)
    end,
  },
  { "echasnovski/mini.surround", version = false, opts = {} },
  -- {
  --   "echasnovski/mini.comment",
  --   dependencies = {
  --     "JoosepAlviste/nvim-ts-context-commentstring",
  --   },
  --   version = false,
  --   config = function()
  --     require("mini.comment").setup({
  --       options = {
  --         custom_commentstring = function()
  --           return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
  --         end,
  --       },
  --     })
  --   end,
  -- },
  {
    "echasnovski/mini.move",
    version = false,
    opts = {
      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
        right = "<M-l>",
        left = "<M-h>",
        down = "<M-j>",
        up = "<M-k>",

        -- Move current line in Normal mode
        line_right = "<M-l>",
        line_left = "<M-h>",
        line_down = "<M-j>",
        line_up = "<M-k>",
      },

      -- Options which control moving behavior
      options = {
        -- Automatically reindent selection during linewise vertical move
        reindent_linewise = true,
      },
    },
  },
  -- auto pairs
  {
    "echasnovski/mini.pairs",
    version = false,
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string" },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    },
    config = function(_, opts)
      require("mini.pairs").setup(opts)
    end,
  },
}
