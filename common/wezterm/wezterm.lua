return {
	enable_wayland = false,
	color_scheme = "Syft",
	font = (require("wezterm")).font("JetBrainsMono Nerd Font"),
	default_cursor_style = "BlinkingBar",
	window_close_confirmation = "NeverPrompt",
	hide_tab_bar_if_only_one_tab = true,
	window_padding = {
		top = "10px",
		right = "10px",
		bottom = "10px",
		left = "10px",
	},

	font_size = 11,
	window_decorations = "NONE",
	window_background_opacity = 0.9,
	text_background_opacity = 1,
	-- keys = require("keys")
	-- default_prog = { '/bin/fish', '-c','br' }
}
