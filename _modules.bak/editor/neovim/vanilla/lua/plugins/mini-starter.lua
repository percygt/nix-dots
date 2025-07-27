return {
  "echasnovski/mini.starter",
  version = false,
  event = "VimEnter",
  dependencies = {
    { "echasnovski/mini.sessions", version = false },
  },
  opts = function() end,
  config = function()
    local header_art = [[

                          ██    ██    ██
                        ██      ██  ██
                        ██    ██    ██
                          ██  ██      ██
                          ██    ██    ██

                      ████████████████████
                      ██░░░░░░░░░░░░░░░░██████
                      ██░░░░░░░░░░░░░░░░██  ██
                      ██░░░░░░░░░░░░░░░░██  ██
                      ██░░░░░░░░░░░░░░░░██████
                      ▀▀██░░░░░░░░░░░░██▀▀
                    ████████████████████████
                    ▀▀████████████████████▀▀

                                                                  ]]
    -- NOTE: MINI SESSIONS
    require("mini.sessions").setup({
      autoread = false,
      autowrite = false,
      directory = vim.fn.stdpath("data") .. "/sessions/",
      file = "", -- 'Session.vim',
    })
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniStarterOpened",
        callback = function()
          require("lazy").show()
        end,
      })
    end
    -- NOTE: MINI STARTER
    local starter = require("mini.starter")
    starter.sections.formatted_sessions = function(n, recent, sub_from, sub_to)
      return vim.tbl_map(function(session)
        session.name = session.name:gsub(sub_from, sub_to)
        session.name = session.name:gsub("%.vim", "")
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
  end,
}
