require("smartcolumn").setup()
require("dressing").setup()
require("trouble").setup()
require("twilight").setup()
require("nvim-web-devicons").set_icon({
	astro = { icon = "󱓞", color = "#FF4900", name = "Astro" },
})
require("notify").setup({
	background_colour = "#000000",
	enabled = false,
})
require("goto-preview").setup({
	dismiss_on_move = true, -- Dismiss the floating window when moving the cursor.
})
require("fidget").setup({
	-- Options related to LSP progress subsystem
	progress = {
		suppress_on_insert = true, -- Suppress new messages while in insert mode
	},
})
require("noice").setup({
	-- add any options here
	routes = {
		{
			filter = {
				event = "msg_show",
				any = {
					{ find = "%d+L, %d+B" },
					{ find = "; after #%d+" },
					{ find = "; before #%d+" },
					{ find = "%d fewer lines" },
					{ find = "%d more lines" },
				},
			},
			opts = { skip = true },
		},
	},
})
