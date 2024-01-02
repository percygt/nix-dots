return {
	enable_wayland = false,
	color_scheme = "Syft",
	font = (require("wezterm")).font("VictorMono Nerd Font", { weight = "Medium" }),
	default_cursor_style = "BlinkingBar",
	enable_tab_bar = false,
	disable_default_key_bindings = true,
	window_close_confirmation = "NeverPrompt",
	window_padding = {
		top = "Opx",
		right = "5px",
		bottom = "0px",
		left = "5px",
	},

	font_size = 11,
	window_decorations = "NONE",
	window_background_opacity = 0.9,
	text_background_opacity = 1,
	keys = {
		{ key = ")",     mods = "CTRL", action = act.ResetFontSize },
		{ key = "-",     mods = "CTRL", action = act.DecreaseFontSize },
		{ key = "=",     mods = "CTRL", action = act.IncreaseFontSize },
		{ key = "V",     mods = "CTRL", action = act.PasteFrom("Clipboard") },
		{ key = "Copy",  mods = "NONE", action = act.CopyTo("Clipboard") },
		{ key = "Paste", mods = "NONE", action = act.PasteFrom("Clipboard") },
		{ key = "F11",   mods = "NONE", action = act.ToggleFullScreen },
		{ key = "F12",   mods = "NONE", action = act.ActivateCommandPalette },
	},
	-- default_prog = { '/bin/fish', '-c','br' }
}
