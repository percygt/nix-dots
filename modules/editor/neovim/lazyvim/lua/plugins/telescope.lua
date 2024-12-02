return {
  -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/editor/telescope.lua
  {
    "nvim-telescope/telescope.nvim",
    keys = function()
      return {
        {
          "<leader>,",
          "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>",
          desc = "Buffers",
        },
        { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
        { "<leader>s", "", desc = "+Search", mode = { "n", "v" } },
        { "<leader>sc", LazyVim.pick.config_files(), desc = "Find Config File" },
        { "<leader>sg", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
        { "<leader>sG", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
        { "<leader>sF", LazyVim.pick("files"), desc = "Find (Root Dir)" },
        { "<leader>sf", LazyVim.pick("files", { root = false }), desc = "Find (cwd)" },
        { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
        { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
        { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
        { "<leader>sc", "<cmd>Telescope commands<cr>", desc = "Commands" },
        { "<leader>sw", LazyVim.pick("grep_string", { word_match = "-w" }), desc = "Word (Root Dir)" },
        { "<leader>sW", LazyVim.pick("grep_string", { root = false, word_match = "-w" }), desc = "Word (cwd)" },
        { "<leader>sw", LazyVim.pick("grep_string"), mode = "v", desc = "Selection (Root Dir)" },
        { "<leader>sW", LazyVim.pick("grep_string", { root = false }), mode = "v", desc = "Selection (cwd)" },
        { "<leader>uC", LazyVim.pick("colorscheme", { enable_preview = true }), desc = "Colorscheme with Preview" },
        {
          "<leader>ss",
          function()
            require("telescope.builtin").lsp_document_symbols({
              symbols = LazyVim.config.get_kind_filter(),
            })
          end,
          desc = "Goto Symbol",
        },
        {
          "<leader>sS",
          function()
            require("telescope.builtin").lsp_dynamic_workspace_symbols({
              symbols = LazyVim.config.get_kind_filter(),
            })
          end,
          desc = "Goto Symbol (Workspace)",
        },
      }
    end,
    opts = function(_, opts)
      local actions = require("telescope.actions")
      local icons = require("config.icons")
      local d = opts.defaults
      local p = opts.pickers
      d.prompt_prefix = " " .. icons.ui.Telescope .. " "
      d.selection_caret = icons.ui.BoldArrowRight .. " "
      d.path_display = { "filename_first" }
      d.previewer = false
      d.file_ignore_patterns = { "node_modules", "package-lock.json" }
      d.initial_mode = "insert"
      d.select_strategy = "reset"
      d.color_devicons = true
      d.set_env = { ["COLORTERM"] = "truecolor" }
      d.layout_config = {
        prompt_position = "top",
        preview_cutoff = 120,
      }
      p.find_files = {
        previewer = false,
        theme = "dropdown",
        layout_config = {
          height = 0.4,
          prompt_position = "bottom",
          preview_cutoff = 120,
        },
        mappings = {
          n = {
            ["l"] = actions.select_default,
          },
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
          },
        },
      }
      p.git_files = {
        previewer = false,
        layout_config = {
          height = 0.4,
          prompt_position = "bottom",
          preview_cutoff = 120,
        },
      }
      p.buffers = {
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
          },
          n = {
            ["<C-d>"] = actions.delete_buffer + actions.move_to_top,
            ["l"] = actions.select_default,
            ["D"] = actions.delete_buffer + actions.move_to_top,
          },
        },
        ignore_current_buffer = true,
        sort_lastused = true,
        previewer = false,
        initial_mode = "normal",
        theme = "dropdown",
        layout_config = {
          height = 0.4,
          width = 0.6,
          prompt_position = "bottom",
          preview_cutoff = 120,
        },
      }
      p.current_buffer_fuzzy_find = {
        previewer = true,
        layout_config = {
          prompt_position = "bottom",
          preview_cutoff = 120,
        },
      }
      p.live_grep = {
        only_sort_text = true,
        previewer = true,
        layout_config = {
          prompt_position = "bottom",
          preview_cutoff = 120,
        },
      }
      p.grep_string = {
        only_sort_text = true,
        previewer = true,
        layout_config = {
          prompt_position = "bottom",
          preview_cutoff = 120,
        },
      }
      p.lsp_references = {
        show_line = false,
        previewer = true,
        layout_config = {
          prompt_position = "bottom",
          preview_cutoff = 120,
        },
      }
      p.treesitter = {
        show_line = false,
        previewer = true,
        layout_config = {
          prompt_position = "bottom",
          preview_cutoff = 120,
        },
      }
    end,
  },
}
