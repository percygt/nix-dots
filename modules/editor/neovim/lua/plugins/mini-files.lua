return {
  "echasnovski/mini.files",
  version = false,
  keys = function()
    local minifiles_open_buffer_path = function()
      local path = vim.bo.buftype ~= "nofile" and vim.api.nvim_buf_get_name(0) or nil
      require("mini.files").open(path)
    end
    return {
      { "<leader>f", minifiles_open_buffer_path, desc = "Files", mode = { "n", "v" } },
    }
  end,
  opts = function()
    local filter_hide = function(fs_entry)
      return not vim.startswith(fs_entry.name, ".")
    end
    return {
      content = { filter = filter_hide },
      options = {
        use_as_default_explorer = true,
      },
      windows = {
        max_number = math.huge,
        preview = true,
        width_focus = 50,
        width_nofocus = 15,
        width_preview = 100,
      },
      mappings = {
        close = "<esc>",
        go_in = "L",
        go_in_plus = "l",
      },
    }
  end,
  config = function(_, opts)
    local mini_files = require("mini.files")
    mini_files.setup(opts)
    local show_dotfiles = false
    local filter_show = function()
      return true
    end
    local filter_hide = function(fs_entry)
      return not vim.startswith(fs_entry.name, ".")
    end
    local toggle_dotfiles = function()
      show_dotfiles = not show_dotfiles
      local new_filter = show_dotfiles and filter_show or filter_hide
      mini_files.refresh({ content = { filter = new_filter } })
    end
    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        local buf_id = args.data.buf_id
        vim.keymap.set("n", ".", toggle_dotfiles, { buffer = buf_id })
      end,
    })
  end,
}
