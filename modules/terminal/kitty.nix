{
  pkgs,
  libx,
  lib,
  config,
  ...
}: let
  inherit (libx) fonts colors;
  syft = pkgs.writeText "syft.conf" ''
    background            #${colors.default.background}
    foreground            #${colors.default.foreground}
    cursor                #${colors.cursor.background}
    selection_background  #${colors.highlight.background}
    selection_foreground  #${colors.highlight.foreground}
    # black
    color0                #${colors.normal.black}
    color8                #${colors.bright.black}
    # red
    color1                #${colors.normal.red}
    color9                #${colors.bright.red}
    # green
    color2                #${colors.normal.green}
    color10               #${colors.bright.green}
    # yellow
    color3                #${colors.normal.yellow}
    color11               #${colors.bright.yellow}
    # blue
    color4                #${colors.normal.blue}
    color12               #${colors.bright.blue}
    # magenta
    color5                #${colors.normal.magenta}
    color13               #${colors.bright.magenta}
    # cyan
    color6                #${colors.normal.cyan}
    color14               #${colors.bright.cyan}
    # white
    color7                #${colors.normal.white}
    color15               #${colors.bright.white}
  '';
in {
  options.terminal.kitty.home.enable = lib.mkEnableOption "Enable kitty";

  config = lib.mkIf config.terminal.kitty.home.enable {
    programs.kitty = {
      enable = true;
      font = {
        name = "VictorMono NFM Medium";
        inherit (fonts.shell) size;
        package = fonts.shell.package pkgs;
      };
      extraConfig = ''
        include ${syft}
      '';
      # theme = "syft";
      settings = {
        shell = "${pkgs.fish}/bin/fish";
        bold_font = "VictorMono NFM Bold";
        shell_integration = "no-cursor";
        disable_ligatures = "never";
        cursor_shape = "block";
        cursor_blink_interval = 1;
        scrollback_lines = 3000;
        scrollback_pager = "less --chop-long-lines --RAW-CONTROL-CHARS +INPUT_LINE_NUMBER";
        scrollback_pager_history_size = 20;
        wheel_scroll_multiplier = 5;
        touch_scroll_multiplier = 1;
        enable_audio_bell = "no";
        tab_bar_edge = "bottom";
        tab_bar_margin_width = 0;
        tab_bar_style = "fade";
        tab_bar_min_tabs = 2;
        active_tab_foreground = "#aeb3bb";
        active_tab_background = "#434c5e";
        active_tab_font_style = "bold";
        inactive_tab_foreground = "#68809a";
        inactive_tab_background = "#373e4d";
        kitty_mod = "alt";
        # For nnn previews
        allow_remote_control = "yes";
        listen_on = "unix:/tmp/kitty";
        enabled_layouts = "splits";
      };
      keybindings = {
        "ctrl+shift+c" = "copy_to_clipboard";
        "ctrl+shift+v" = "paste_from_clipboard";
        "kitty_mod+enter" = "new_os_window_with_cwd";
        "kitty_mod+t" = "new_tab_with_cwd !neighbor";
        "kitty_mod+l" = "next_tab";
        "kitty_mod+h" = "previous_tab";
        "kitty_mod+k" = "scroll_line_up";
        "kitty_mod+j" = "scroll_line_down";
        "kitty_mod+u" = "scroll_to_prompt -1";
        "kitty_mod+d" = "scroll_to_prompt 1";
        "kitty_mod+p" = "show_scrollback";
        "kitty_mod+up" = "scroll_page_up";
        "kitty_mod+down" = "scroll_page_down";
        "ctrl+equal" = "change_font_size all ${builtins.toString fonts.shell.size}";
        "ctrl+plus" = "change_font_size all +0.5";
        "ctrl+minus" = "change_font_size all -0.5";
      };
    };
  };
}
