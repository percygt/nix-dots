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
        autumn_night_transparent = {
          "inherits" = "autumn_night";
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
        theme = "autumn_night_transparent";
        editor = {
          gutters = [
            "diff"
            "line-numbers"
            "spacer"
            "diagnostics"
          ];
          cursorline = true;
          # cursor-shape = {
          #   normal = "block";
          #   insert = "bar";
          #   select = "underline";
          # };
          true-color = true;
          lsp.display-messages = true;
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
