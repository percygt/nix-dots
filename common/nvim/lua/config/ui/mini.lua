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
-- using the mini plugins
require("mini.sessions").setup({
  autoread = false,
  autowrite = false,
  directory = vim.fn.stdpath("data") .. "/sessions/",
  file = "", -- 'Session.vim',
})

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

local mini_files = require("mini.files")
local show_dotfiles = false
local filter_show = function(fs_entry)
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
    go_in = "L",
    go_in_plus = "l",
  },
})

local keymap = require("config.helpers")
local nnoremap = keymap.nnoremap
local minifiles_toggle = function(...)
  if not mini_files.close() then
    mini_files.open(...)
  end
end
nnoremap("-", minifiles_toggle) -- open file browser
