return {
	enable_wayland = false,
	color_schemes = {
		["Syft Dark"] = require("syft"),
	},
	color_scheme = "Syft Dark",
	font = (require 'wezterm').font("JetBrainsMono Nerd Font"),
	default_cursor_style = "BlinkingBar",
	window_close_confirmation = "NeverPrompt",
	hide_tab_bar_if_only_one_tab = true,
	window_padding = {
		top = "10px",
		right = "10px",
		bottom = "10px",
		left = "10px",
	},

	-- inactive_pane_hsb = {
	-- 	saturation = 0.1,
	-- 	brightness = 0.1,
	-- },
	-- front_end = "OpenGL",
	font_size = 11,
	window_decorations = "NONE",
	window_background_opacity = 0.7,
	text_background_opacity = 0.5,
	window_frame = {
		inactive_titlebar_bg = '#353535',
		active_titlebar_bg = '#2b2042',
		inactive_titlebar_fg = '#cccccc',
		active_titlebar_fg = '#ffffff',
		inactive_titlebar_border_bottom = '#2b2042',
		active_titlebar_border_bottom = '#2b2042',
		button_fg = '#cccccc',
		button_bg = '#2b2042',
		button_hover_fg = '#ffffff',
		button_hover_bg = '#3b3052',
	},
	-- keys = require("keys")
	-- default_prog = { '/bin/fish', '-c','br' }
}
