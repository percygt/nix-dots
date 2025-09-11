return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        layout = {
          cycle = false,
          --- Use the default layout or vertical if the window is too narrow
          preset = function()
            return vim.o.columns >= 120 and "ivy" or "vertical"
          end,
        },
        layouts = {
          vertical = {
            layout = {
              backdrop = false,
              width = 0.8,
              min_width = 80,
              height = 0.8,
              min_height = 30,
              box = "vertical",
              border = "rounded",
              title = "{title} {live} {flags}",
              title_pos = "center",
              { win = "input", height = 1, border = "bottom" },
              { win = "list", border = "none" },
              { win = "preview", title = "{preview}", height = 0.4, border = "top" },
            },
          },
          ivy = {
            reverse = true,
            layout = {
              box = "vertical",
              backdrop = false,
              row = -1,
              width = 0,
              height = 0.5,
              border = "top",
              {
                box = "horizontal",
                { win = "list", border = "none" },
                { win = "preview", title = "{preview}", width = 0.5, border = "left" },
              },
              {
                win = "input",
                height = 1,
                border = "top",
                title_pos = "left",
                title = "{title} {live} {flags}",
              },
            },
          },
          custom = {
            reverse = true,
            layout = {
              box = "vertical",
              backdrop = false,
              width = 0.3,
              height = 0.3,
              border = "rounded",
              { win = "list" },
              {
                win = "input",
                height = 1,
                border = "top",
                title = "{title} {live} {flags}",
              },
            },
          },
        },
        sources = {
          yanky = {
            on_show = function()
              vim.cmd.stopinsert()
            end,
          },
          cliphist = {
            on_show = function()
              vim.cmd.stopinsert()
            end,
          },
          files = {
            layout = "custom",
          },
          smart = {
            layout = "custom",
          },
          buffers = {
            on_show = function()
              vim.cmd.stopinsert()
            end,
            current = false,
            layout = "custom",
            win = {
              input = {
                keys = {
                  ["d"] = { "bufdelete", mode = { "n", "i" } },
                },
              },
            },
          },
        },
      },
    },
    -- stylua: ignore
    keys =  {
        -- search
        { "<leader>fB", false },
        { "<leader>fb", false },
        { "<leader>fc", false },
        { "<leader>ff", false },
        { "<leader>fF", false },
        { "<leader>fg", false },
        { "<leader>fp", false },
        { "<leader>fr", false },
        { "<leader>fR", false },
        { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
        { "<leader>P", function() Snacks.picker.cliphist() end, desc = "Cliphist" },
        { "<leader>/",  LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
        { "<leader>sb", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>sb", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>sB", function() Snacks.picker.buffers({ hidden = true, nofile = true }) end, desc = "Buffers (all)" },
        { "<leader>sx", LazyVim.pick.config_files(), desc = "Find Config File" },
        { "<leader>sf", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
        { "<leader>sF", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
        { "<leader>sP", function() Snacks.picker.projects() end, desc = "Projects" },
    },
  },
  {
    "ibhagwan/fzf-lua",
    enabled = false,
    opts = function(_, opts)
      opts.files = {
        cwd_prompt = false,
        header = false,
        winopts = {
          preview = { hidden = "hidden" },
          width = 0.5,
          height = 0.5,
        },
      }
      opts.fzf_opts["--layout"] = "default"
      opts.fzf_opts["--border-label-pos"] = "0:bottom"
      return opts
    end,
    keys = function()
      local function symbols_filter(entry, ctx)
        if ctx.symbols_filter == nil then
          ctx.symbols_filter = LazyVim.config.get_kind_filter(ctx.bufnr) or false
        end
        if ctx.symbols_filter == false then
          return true
        end
        return vim.tbl_contains(ctx.symbols_filter, entry.kind)
      end
      return {
        { "<leader>s", "", desc = "+Search", mode = { "n", "v" } },
        {
          "<leader>,",
          "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>",
          desc = "Switch Buffer",
        },
        { "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
        { "<leader>sc", LazyVim.pick.config_files(), desc = "Find Config File" },
        { "<leader>sg", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
        { "<leader>sG", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
        { "<leader>sF", LazyVim.pick("files"), desc = "Find (Root Dir)" },
        { "<leader>sf", LazyVim.pick("files", { root = false }), desc = "Find (cwd)" },
        { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help Pages" },
        { "<leader>sH", "<cmd>FzfLua highlights<cr>", desc = "Search Highlight Groups" },
        { "<leader>sj", "<cmd>FzfLua jumps<cr>", desc = "Jumplist" },
        { "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
        { "<leader>sl", "<cmd>FzfLua loclist<cr>", desc = "Location List" },
        { "<leader>sM", "<cmd>FzfLua man_pages<cr>", desc = "Man Pages" },
        { "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Jump to Mark" },
        { "<leader>sR", "<cmd>FzfLua resume<cr>", desc = "Resume" },
        { "<leader>sq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix List" },
        { "<leader>sd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
        { "<leader>sD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics" },
        { "<leader>sc", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
        { "<leader>sC", "<cmd>FzfLua commands<cr>", desc = "Commands" },
        { "<leader>sw", LazyVim.pick("grep_cword"), desc = "Word (Root Dir)" },
        { "<leader>sW", LazyVim.pick("grep_cword", { root = false }), desc = "Word (cwd)" },
        { "<leader>sw", LazyVim.pick("grep_visual"), mode = "v", desc = "Selection (Root Dir)" },
        { "<leader>sW", LazyVim.pick("grep_visual", { root = false }), mode = "v", desc = "Selection (cwd)" },
        { "<leader>uC", LazyVim.pick("colorscheme", { enable_preview = true }), desc = "Colorscheme with Preview" },
        {
          "<leader>ss",
          function()
            require("fzf-lua").lsp_document_symbols({
              regex_filter = symbols_filter,
            })
          end,
          desc = "Goto Symbol",
        },
        {
          "<leader>sS",
          function()
            require("fzf-lua").lsp_live_workspace_symbols({
              regex_filter = symbols_filter,
            })
          end,
          desc = "Goto Symbol (Workspace)",
        },
      }
    end,
  },
  -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/editor/telescope.lua
  {
    "nvim-telescope/telescope.nvim",
    enabled = false,
    keys = function()
      return {
        {
          "<leader>,",
          "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>",
          desc = "Buffers",
        },
        { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
        { "<leader>s", "", desc = "+Search", mode = { "n", "v" } },
        { "<leader>s.", LazyVim.pick.config_files(), desc = "Find Config File" },
        { "<leader>sg", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
        { "<leader>sG", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
        { "<leader>sF", LazyVim.pick("files"), desc = "Find (Root Dir)" },
        { "<leader>sf", LazyVim.pick("files", { root = false }), desc = "Find (cwd)" },
        { "<leader><leader>", LazyVim.pick("files", { root = false }), desc = "Find (cwd)" },
        { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
        { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
        { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
        { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
        { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
        { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
        { "<leader>sj", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
        { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
        { "<leader>sl", "<cmd>Telescope loclist<cr>", desc = "Location List" },
        { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
        { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
        { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
        { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
        { "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix List" },
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
      d.prompt_prefix = " " .. icons.ui.Telescope .. "  "
      d.selection_caret = " " .. icons.ui.LineRight .. " "
      d.path_display = { "filename_first" }
      d.previewer = false
      d.file_ignore_patterns = { "node_modules", "package-lock.json" }
      d.initial_mode = "insert"
      d.select_strategy = "reset"
      d.color_devicons = true
      d.set_env = { ["COLORTERM"] = "truecolor" }
      d.layout_config = {
        prompt_position = "bottom",
        preview_cutoff = 120,
        vertical = { mirror = false },
      }
      d.mappings.i["<esc>"] = actions.close
      d.mappings.i["<C-u>"] = false
      d.mappings.i["<C-d>"] = false
      d.mappings.i["<C-j>"] = actions.move_selection_next
      d.mappings.i["<C-k>"] = actions.move_selection_previous
      p.find_files = {
        previewer = false,
        theme = "dropdown",
        sorting_strategy = "descending",
        layout_config = {
          height = 0.5,
          width = 0.5,
          prompt_position = "bottom",
          preview_cutoff = 120,
        },
        mappings = {
          n = {
            ["l"] = actions.select_default,
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
          n = {
            ["l"] = actions.select_default,
            ["D"] = actions.delete_buffer + actions.move_to_bottom,
          },
        },
        ignore_current_buffer = true,
        sort_lastused = true,
        previewer = false,
        initial_mode = "normal",
        theme = "dropdown",
        sorting_strategy = "descending",
        layout_config = {
          height = 0.5,
          width = 0.5,
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
