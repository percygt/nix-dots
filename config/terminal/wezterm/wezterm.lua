local wezterm = require("wezterm")
local nix = require("nix")

wezterm.on("toggle-opacity", function(window)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 1
	else
		overrides.window_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end)

wezterm.on("format-window-title", function()
	return "Wezterm"
end)

wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
		else
			overrides.font_size = number_value
		end
	end
	window:set_config_overrides(overrides)
end)

return {
	enable_wayland = true,
	enable_kitty_graphics = true,
	check_for_updates = false,
	color_scheme = "Syft",
	font = nix.font,
	font_size = nix.font_size,
	allow_square_glyphs_to_overflow_width = "Always",
	animation_fps = 30,
	cursor_blink_rate = 500,
	default_cursor_style = "BlinkingBlock",
	warn_about_missing_glyphs = false,
	enable_scroll_bar = false,
	enable_tab_bar = false,
	front_end = "WebGpu",
	disable_default_key_bindings = true,
	window_close_confirmation = "NeverPrompt",
	line_height = 1.2,
	window_padding = {
		left = 5,
		right = 5,
		top = 7,
		bottom = 7,
	},
	visual_bell = {
		fade_in_duration_ms = 75,
		fade_out_duration_ms = 75,
		target = "CursorColor",
	},
	window_decorations = "NONE",
	window_background_opacity = nix.window_background_opacity,
	text_background_opacity = 1,
	keys = {
		{ key = "0", mods = "CTRL|SHIFT", action = wezterm.action.ResetFontSize },
		{ key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
		{ key = "=", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
		{ key = "V", mods = "CTRL", action = wezterm.action.PasteFrom("Clipboard") },
		{ key = "Copy", mods = "NONE", action = wezterm.action.CopyTo("Clipboard") },
		{ key = "Paste", mods = "NONE", action = wezterm.action.PasteFrom("Clipboard") },
		{ key = "*", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("toggle-opacity") },
		{ key = "F11", mods = "NONE", action = wezterm.action.ToggleFullScreen },
		{ key = "F12", mods = "NONE", action = wezterm.action.ActivateCommandPalette },
	},
	default_ssh_auth_sock = nix.default_ssh_auth_sock,
	mux_enable_ssh_agent = false,
	mux_env_remove = {
		-- "SSH_AUTH_SOCK", don't remove
		"SSH_CLIENT",
		"SSH_CONNECTION",
	},
	default_gui_startup_args = { "start", "--always-new-process" },
	default_prog = nix.default_prog,
}
