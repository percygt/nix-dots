local M = {}
local formatter = require("formatter")

function format.setup_servers(json_config)
	local f = io.open(json_config, "r")
	if not f then
		return
	end
	local format_config = vim.json.decode(f:read("all*"))
	f:close()
	if format_config == nil then
		return
	end
	-- local ok, yaml_companion = pcall(require, "yaml-companion")
	-- if ok then
	-- 	format_config.yamlls = yaml_companion.setup({})
	-- end
  local config = {}
  local filetype = {}
	for lang, config in pairs(format_config) do
    filetype[lang] = {
        local formatter = "prettier"
        local lang = "javascript"
        local modulePath = "formatter.filetypes." .. lang .. "." .. formatter
        local module = require(modulePath)
    }
	end
  return formatter.setup(config)
end

return M

formatter.setup({
	logging = true,
	filetype = {
		javascript = {
			require("formatter.filetypes.javascript").prettier,
		},
		typescript = {
			require("formatter.filetypes.typescript").prettier,
		},
		astro = {
			require("formatter.filetypes.astro").prettier,
      function()
        return {
          exe = "prettier",
          args = {
            "--search-parent-directories",
            "--stdin-filepath",
            util.escape_path(util.get_current_buffer_file_path()),
            "--",
            "-",
          },
          stdin = true,
        }
      end
		},
		["*"] = {
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})