local header_art = [[
                                                         
      ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ 
      ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ 
      ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ 
      ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ 
      ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ 
      ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ 
                                                         ]]
-- using the mini plugins
require("mini.sessions").setup({
  -- Whether to read latest session if Neovim opened without file arguments
  autoread = false,
  -- Whether to write current session before quitting Neovim
  autowrite = false,
  -- Directory where global sessions are stored (use `''` to disable)
  directory = vim.fn.stdpath("data") .. "/sessions/", --<"session" subdir of user data directory from |stdpath()|>,
  -- File for local session (use `''` to disable)
  file = "", -- 'Session.vim',
})

local starter = require("mini.starter")
starter.sections.formatted_sessions = function()
  local items = {}
  for _, session in ipairs(starter.sections.sessions(10, true)()) do
    session.name = session.name:gsub("__", "/")
    table.insert(items, session)
  end
  return items
end
starter.setup({
  -- evaluate_single = true,
  items = {
    starter.sections.formatted_sessions(),
    starter.sections.builtin_actions(),
  },
  content_hooks = {
    function(content)
      local blank_content_line = { { type = "empty", string = "" } }
      local section_coords = starter.content_coords(content, "section")
      -- Insert backwards to not affect coordinates
      for i = #section_coords, 1, -1 do
        table.insert(content, section_coords[i].line + 1, blank_content_line)
      end
      return content
    end,
    starter.gen_hook.adding_bullet("» "),
    starter.gen_hook.aligning("center", "center"),
  },
  header = header_art,
  footer = "",
})
require("mini.files").setup({
  options = {
    -- Whether to delete permanently or move into module-specific trash
    permanent_delete = false,
    -- Whether to use for editing directories
    use_as_default_explorer = true,
  },

  -- Customization of explorer windows
  windows = {
    -- Maximum number of windows to show side by side
    max_number = math.huge,
    -- Whether to show preview of file/directory under cursor
    preview = true,
    -- Width of focused window
    width_focus = 50,
    -- Width of non-focused window
    width_nofocus = 15,
    -- Width of preview window
    width_preview = 100,
  },
})

local keymap = require("config.keymap")
local nnoremap = keymap.nnoremap

nnoremap("-", "<cmd>lua MiniFiles.open()<cr>") -- open file browser
