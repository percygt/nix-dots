{
  pkgs,
  libx,
  isGeneric,
  flakeDirectory,
  homeDirectory,
  ...
}: let
  inherit (libx) colors fonts;
  window-title = "Wezterm";
  launch-tmux = pkgs.writers.writeBash "launch-tmux" ''
    if [ -d ${flakeDirectory} ]; then
      tmux has-session -t nix-dots 2>/dev/null
      if [ $? != 0 ]; then
        tmux new-session -ds nix-dots -c "${flakeDirectory}"
      fi
      tmux new-session -As nix-dots
    else
      tmux has-session -t home 2>/dev/null
      if [ $? != 0 ]; then
        tmux new-session -ds home -c "${homeDirectory}"
      fi
      tmux new-session -As home
    fi
  '';
in {
  programs.wezterm = {
    enable = true;
    package =
      if isGeneric
      then pkgs.stash.wezterm_wrapped
      else pkgs.stash.wezterm_nightly;
    colorSchemes = {
      Syft = {
        ansi = [
          "#${colors.normal.black}"
          "#${colors.normal.red}"
          "#${colors.normal.green}"
          "#${colors.normal.yellow}"
          "#${colors.normal.blue}"
          "#${colors.normal.magenta}"
          "#${colors.normal.cyan}"
          "#${colors.normal.white}"
        ];
        brights = [
          "#${colors.bright.black}"
          "#${colors.bright.red}"
          "#${colors.bright.green}"
          "#${colors.bright.yellow}"
          "#${colors.bright.blue}"
          "#${colors.bright.magenta}"
          "#${colors.bright.cyan}"
          "#${colors.bright.white}"
        ];
        foreground = "#${colors.default.foreground}";
        background = "#${colors.default.background}";
        cursor_fg = "#${colors.cursor.foreground}";
        cursor_bg = "#${colors.cursor.background}";
        cursor_border = "#${colors.cursor.background}";
        selection_bg = "#${colors.highlight.background}";
      };
    };
    extraConfig =
      /*
      lua
      */
      ''
        local wezterm = require("wezterm")
        wezterm.on("toggle-opacity", function(window)
          local overrides = window:get_config_overrides() or {}
          if not overrides.window_background_opacity then
            overrides.window_background_opacity = 1
          else
            overrides.window_background_opacity = nil
          end
          window:set_config_overrides(overrides)
        end)
        wezterm.on('format-window-title', function()
          return "${window-title}"
        end)
        wezterm.on('user-var-changed', function(window, pane, name, value)
            local overrides = window:get_config_overrides() or {}
            if name == "ZEN_MODE" then
                local incremental = value:find("+")
                local number_value = tonumber(value)
                if incremental ~= nil then
                    while (number_value > 0) do
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
          check_for_updates = false,
        	color_scheme = "Syft",
        	font = wezterm.font("${fonts.shell.name}", { weight = "DemiBold" }),
        	font_size = tonumber("${builtins.toString fonts.shell.size}"),
          allow_square_glyphs_to_overflow_width = "Always",
          animation_fps = 30,
          cursor_blink_rate = 500,
          default_cursor_style = "BlinkingBlock",
          warn_about_missing_glyphs = false,
          enable_scroll_bar = false,
          enable_tab_bar = false,
          front_end="OpenGL",
        	disable_default_key_bindings = true,
        	window_close_confirmation = "NeverPrompt",
          window_padding = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0,
          },
          visual_bell = {
              fade_in_function = "Ease",
              fade_in_duration_ms = 150,
              fade_out_function = "Ease",
              fade_out_duration_ms = 150,
          },
        	window_decorations = "NONE",
        	window_background_opacity = ${builtins.toString colors.alpha},
        	text_background_opacity = 1,
        	keys = {
        		{ key = "0",      mods = "CTRL|SHIFT",  action = wezterm.action.ResetFontSize },
        		{ key = "-",      mods = "CTRL",  action = wezterm.action.DecreaseFontSize },
        		{ key = "=",      mods = "CTRL",  action = wezterm.action.IncreaseFontSize },
        		{ key = "V",      mods = "CTRL",  action = wezterm.action.PasteFrom("Clipboard") },
        		{ key = "Copy",   mods = "NONE",  action = wezterm.action.CopyTo("Clipboard") },
        		{ key = "Paste",  mods = "NONE",  action = wezterm.action.PasteFrom("Clipboard") },
            { key = "*",      mods = "CTRL|SHIFT",  action = wezterm.action.EmitEvent("toggle-opacity") },
        		{ key = "F11",    mods = "NONE",  action = wezterm.action.ToggleFullScreen },
        		{ key = "F12",    mods = "NONE",  action = wezterm.action.ActivateCommandPalette },
        	},
          default_gui_startup_args = {'start', '--always-new-process'},
        	default_prog = { '${launch-tmux}' }
        }
      '';
  };
}
