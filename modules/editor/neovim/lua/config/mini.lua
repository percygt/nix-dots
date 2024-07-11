local header_art = [[
                                                                  
                                                                  
                                                                  
                          ██    ██    ██                          
                        ██      ██  ██                            
                        ██    ██    ██                            
                          ██  ██      ██                          
                          ██    ██    ██                          
                                                                  
                      ████████████████████                        
                      ██                ██████                    
                      ██                ██  ▓▓                    
                      ██                ██  ██                    
                      ██                ██████                    
                        ██            ██                          
                    ████████████████████████                      
                    ██                    ▓▓                      
                      ████████████████████                        
                                                                  
                                                                  
                                                                  
                                                                  ]]

-- Better Around/Inside textobjects
--
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [']quote
--  - ci'  - [C]hange [I]nside [']quote
require("mini.ai").setup({ n_lines = 500 })

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require("mini.surround").setup()

require("mini.pairs").setup()

-- Simple and easy statusline.
--  You could remove this setup call if you don't like it,
--  and try some other statusline plugin
local statusline = require("mini.statusline")
-- set use_icons to true if you have a Nerd Font
statusline.setup({ use_icons = vim.g.have_nerd_font })

-- You can configure sections in the statusline by overriding their
-- default behavior. For example, here we set the section for
-- cursor location to LINE:COLUMN
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return "%2l:%-2v"
end
-- NOTE: MINI ICONS
require("mini.icons").setup()

-- NOTE: MINI SURROUND
require("mini.surround").setup()

-- NOTE: MINI PAIRS
require("mini.pairs").setup()

-- NOTE: MINI MOVE
require("mini.move").setup()

-- NOTE: MINI SESSIONS
require("mini.sessions").setup({
  autoread = false,
  autowrite = false,
  directory = vim.fn.stdpath("data") .. "/sessions/",
  file = "", -- 'Session.vim',
})
-- NOTE: MINI STARTER
local starter = require("mini.starter")
starter.sections.formatted_sessions = function(n, recent, sub_from, sub_to)
  return vim.tbl_map(function(session)
    session.name = session.name:gsub(sub_from, sub_to)
    return session
  end, starter.sections.sessions(n, recent)())
end
starter.setup({
  -- evaluate_single = true,
  items = {
    starter.sections.formatted_sessions(50, true, "__", "/"),
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

-- NOTE: MINI FILES
local mini_files = require("mini.files")
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
mini_files.setup({
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
})

local keymap = require("config.helpers")
local nnoremap = keymap.nnoremap
-- local minifiles_toggle = function(...)
--   if not mini_files.close() then
--     mini_files.open(...)
--   end
-- end
nnoremap("<leader>f", "<cmd>lua require('mini.files').open()<cr>") -- open file browser
