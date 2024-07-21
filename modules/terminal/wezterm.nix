{
  pkgs,
  lib,
  config,
  isGeneric,
  flakeDirectory,
  homeDirectory,
  ...
}:
let
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
  t = config.setTheme;
  f = config.setFonts.shell;
  c = t.colors.withHashtag;
in
{
  options.terminal.wezterm.home.enable = lib.mkEnableOption "Enable wezterm";

  config = lib.mkIf config.terminal.wezterm.home.enable {
    programs.wezterm = {
      enable = true;
      package = if isGeneric then pkgs.stash.wezterm_wrapped else pkgs.stash.wezterm_nightly;
      colorSchemes = {
        Syft = {
          ansi = [
            c.base01
            c.base08 # red
            c.base0B # green
            c.base09 # yellow
            c.base0D # blue
            c.base0E # magenta
            c.base0C # cyan
            c.base06
          ];
          brights = [
            c.base02
            c.base12 # bright red
            c.base14 # bright green
            c.base13 # bright yellow
            c.base16 # bright blue
            c.base17 # bright magenta
            c.base15 # bright cyan
            c.base07
          ];
          foreground = c.base05;
          background = c.base00;
          cursor_bg = c.base05;
          cursor_border = c.base05;
          selection_fg = "none";
          selection_bg = c.base02;
        };
      };
      extraConfig =
        # lua
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
            enable_kitty_graphics = true,
            check_for_updates = false,
          	color_scheme = "Syft",
          	font = wezterm.font("${f.name}", { weight = "DemiBold" }),
          	font_size = tonumber("${builtins.toString f.size}"),
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
                target = 'CursorColor',
            },
          	window_decorations = "NONE",
          	window_background_opacity = ${builtins.toString t.opacity},
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
  };
}
