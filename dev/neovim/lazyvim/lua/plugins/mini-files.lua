return {
  "echasnovski/mini.files",
  init = function()
    -- delete lazygit keymap for file history
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimKeymaps",
      once = true,
      callback = function()
        pcall(vim.keymap.del, "n", "<leader>fn")
        pcall(vim.keymap.del, "n", "<leader>ft")
        pcall(vim.keymap.del, "n", "<leader>fT")
      end,
    })
    local files_grug_far_replace = function(path)
      -- works only if cursor is on the valid file system entry
      local cur_entry_path = MiniFiles.get_fs_entry().path
      local prefills = { paths = vim.fs.dirname(cur_entry_path) }

      local grug_far = require("grug-far")

      -- instance check
      if not grug_far.has_instance("explorer") then
        grug_far.open({
          instanceName = "explorer",
          prefills = prefills,
          staticTitle = "Find and Replace from Explorer",
        })
      else
        grug_far.get_instance("explorer"):open()
        -- updating the prefills without crealing the search and other fields
        grug_far.get_instance("explorer"):update_input_values(prefills, false)
      end
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        vim.keymap.set("n", "gs", files_grug_far_replace, { buffer = args.data.buf_id, desc = "Search in directory" })
      end,
    })
  end,
  keys = {
    { "<leader>fm", false },
    { "<leader>fM", false },
    {
      "<leader>f",
      function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
      end,
      desc = "Files",
    },
    {
      "<leader>F",
      function()
        require("mini.files").open(vim.uv.cwd(), true)
      end,
      desc = "Files (cwd)",
    },
  },
  opts = function(_, opts)
    opts.options = {
      use_as_default_explorer = true,
    }
    opts.windows = {
      max_number = math.huge,
      preview = true,
      width_focus = 60,
      width_nofocus = 15,
      width_preview = 125,
    }
    opts.mappings = {
      close = "q",
      go_in = "L",
      go_in_plus = "l",
    }
  end,
}
