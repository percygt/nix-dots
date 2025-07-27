return {
	{
		"Olical/conjure",
		ft = { "clojure", "fennel" }, -- etc
		lazy = true,
		init = function()
			-- Set configuration options here
			-- vim.g["conjure#debug"] = true
			vim.g["conjure#mapping#prefix"] = ","
			vim.g["conjure#log#hud#width"] = 1
			vim.g["conjure#log#hud#height"] = 0.6
			vim.g["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = false
			vim.g["conjure#eval#gsubs"] = {
				["do-comment"] = { "^%(comment[%s%c]", "(do " },
			}
			vim.g["conjure#eval#result_register"] = "*"
			vim.g["conjure#mapping#doc_word"] = "<localleader>K"
			vim.g["conjure#client_on_load"] = false
		end,

		-- Optional cmp-conjure integration
		dependencies = { "PaterJason/cmp-conjure" },
	},
	{
		"PaterJason/cmp-conjure",
		lazy = true,
		config = function()
			local cmp = require("cmp")
			local config = cmp.get_config()
			table.insert(config.sources, { name = "conjure" })
			return cmp.setup(config)
		end,
	},
}
