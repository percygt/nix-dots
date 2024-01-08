{
  pkgs,
  lib,
  ...
}: let
  colors = (import ../../colors.nix).syft;
  nixgl = import ../../nixgl.nix {
    inherit pkgs lib;
  };
  wrapped_wezterm = nixgl.nixGLVulkanMesaWrap pkgs.wezterm_custom;
in {
  home.packages = [
    (pkgs.makeDesktopItem {
      name = "wezterm";
      desktopName = "WezTerm";
      comment = "Wez's Terminal Emulator";
      keywords = ["shell" "prompt" "command" "commandline" "cmd"];
      icon = "org.wezfurlong.wezterm";
      startupWMClass = "org.wezfurlong.wezterm";
      tryExec = "${wrapped_wezterm}/bin/wezterm";
      exec = "${wrapped_wezterm}/bin/wezterm start --cwd .";
      type = "Application";
      categories = ["System" "TerminalEmulator" "Utility"];
      terminal = false;
    })
  ];

  programs.wezterm = {
    enable = true;
    package = wrapped_wezterm;
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
    extraConfig = ''
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
      return {
      	enable_wayland = false,
        check_for_updates = false,
      	color_scheme = "Syft",
      	font = wezterm.font("VictorMono Nerd Font", { weight = "Medium" }),
      	default_cursor_style = "BlinkingBar",
        enable_scroll_bar = false,
        enable_tab_bar = false,
      	disable_default_key_bindings = true,
      	window_close_confirmation = "NeverPrompt",
        window_padding = {
          left = "5px",
          right = "5px",
          top = 0,
          bottom = 0,
        },

      	font_size = 11,
      	window_decorations = "NONE",
      	window_background_opacity = 0.8,
      	text_background_opacity = 1,
      	keys = {
      		{ key = "0",      mods = "CTRL|SHIFT",  action = wezterm.action.ResetFontSize },
      		{ key = "-",      mods = "CTRL",  action = wezterm.action.DecreaseFontSize },
      		{ key = "=",      mods = "CTRL",  action = wezterm.action.IncreaseFontSize },
      		{ key = "V",      mods = "CTRL",  action = wezterm.action.PasteFrom("Clipboard") },
      		{ key = "Copy",   mods = "NONE",  action = wezterm.action.CopyTo("Clipboard") },
      		{ key = "Paste",  mods = "NONE",  action = wezterm.action.PasteFrom("Clipboard") },
      		{ key = "F10",    mods = "NONE",  action = wezterm.action.EmitEvent("toggle-opacity") },
      		{ key = "F11",    mods = "NONE",  action = wezterm.action.ToggleFullScreen },
      		{ key = "F12",    mods = "NONE",  action = wezterm.action.ActivateCommandPalette },
      	},
      	default_prog = { 'tmux', 'new', '-As', 'main' }
      }
    '';
  };
}
