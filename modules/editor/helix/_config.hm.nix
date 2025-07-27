{
  pkgs,
  config,
  lib,
  ...
}:
let
  f = config.modules.fonts.shell;
in
{
  config = lib.mkIf config.modules.editor.helix.enable {
    programs.helix = {
      enable = true;
      package = pkgs.evil-helix;

      themes = {
        catppuccin_macchiato_transparent = {
          "inherits" = "catppuccin_macchiato";
          "ui.background" = { };
        };
      };
      languages.language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${lib.getExe pkgs.nixfmt-rfc-style}";
        }
      ];
      settings = {
        theme = "catppuccin_macchiato_transparent";
        editor = {
          gutters = [
            "diff"
            "diagnostics"
            "line-numbers"
            "spacer"
          ];
          statusline = {
            left = [
              "mode"
              "spinner"
            ];
            center = [ "file-name" ];
            right = [
              "diagnostics"
              "selections"
              "position"
              "file-line-ending"
              "file-type"
              "version-control"
            ];
            separator = "|";
            mode = {
              normal = "NOR";
              insert = "INS";
              select = "SEL";
            };
          };
          auto-save = true;
          color-modes = true;
          cursorline = true;
          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };
          inline-diagnostics = {
            cursor-line = "hint";
            other-lines = "error";
          };
          indent-guides = {
            render = true;
            rainbow = "dim";
            character = "┆";
          };
          whitespace = {
            characters = {
              space = "·";
              nbsp = "⍽";
              tab = "→";
              newline = "⏎";
              tabpad = "·";
            };
          };
          lsp = {
            display-messages = true;
            display-inlay-hints = true;
          };
          true-color = true;
          mouse = false;
          soft-wrap = {
            enable = true;
            wrap-indicator = "";
          };
        };
        keys = {
          insert = {
            esc = [
              "collapse_selection"
              "normal_mode"
            ];
          };
          normal = {
            esc = [
              "collapse_selection"
              "normal_mode"
            ];
            X = "extend_line_above";
            a = [
              "append_mode"
              "collapse_selection"
            ];
            g.q = ":reflow";
            i = [
              "insert_mode"
              "collapse_selection"
            ];
            ret = [
              "move_line_down"
              "goto_line_start"
            ];
            space = {
              w = ":write";
              q = ":quit";
            };
          };
          select = {
            esc = [
              "collapse_selection"
              "keep_primary_selection"
              "normal_mode"
            ];
          };
        };
      };
    };
  };
}
