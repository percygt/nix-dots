{pkgs, ...}: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "base16";
      editor = {
        color-modes = true;
        line-number = "absolute";
        bufferline = "multiple";
        lsp.display-inlay-hints = false;
        cursorline = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        file-picker = {
          hidden = false;
        };
        statusline = {
          left = ["mode" "spinner"];
          center = ["file-name"];
          right = ["file-encoding" "file-line-ending" "file-type"];
          separator = "│";
          mode = {
            normal = "NORMAL";
            insert = "INSERT";
            select = "SELECT";
          };
        };
        indent-guides = {
          render = true;
        };
      };
      keys.normal = {
        space = {
          space = "file_picker";
          w = ":w";
          q = ":q";
        };
        esc = ["collapse_selection" "keep_primary_selection"];
      };
    };
    languages = with pkgs; {
      language-server = {
        astro-ls = {
          command = "${nodePackages."@astrojs/language-server"}/bin/astro-ls";
          args = [
            "--stdio"
          ];
        };
        deno = {
          command = "${deno}/bin/deno";
          args = [
            "lsp"
          ];
        };
        emmet-ls = {
          command = "${emmet-ls}/bin/emmet-ls";
          args = [
            "--stdio"
          ];
        };
        eslint = {
          command = "${nodePackages.vscode-langservers-extracted}/bin/vscode-eslint-language-server";
          args = [
            "--stdio"
          ];
          config = {
            codeActionsOnSave = {
              mode = "all";
              source.fixAll.eslint = true;
            };
            format = {
              enable = true;
            };
            nodePath = "";
            quiet = false;
            rulesCustomizations = [];
            run = "onType";
            validate = "on";
            experimental = {};
            problems = {
              shortenToSingleLine = false;
            };
            codeAction = {
              disableRuleComment = {
                enable = true;
                location = "separateLine";
              };
              showDocumentation = {
                enable = false;
              };
            };
          };
        };
        vscode-json-language-server = {
          config = {
            json = {
              validate = {
                enable = true;
              };
              format = {
                enable = true;
              };
            };
            provideFormatter = true;
          };
        };
        vscode-css-language-server = {
          config = {
            css = {
              validate = {
                enable = true;
              };
            };
            scss = {
              validate = {
                enable = true;
              };
            };
            less = {
              validate = {
                enable = true;
              };
            };
            provideFormatter = true;
          };
        };
      };
      language = [
        {
          name = "astro";
          language-servers = [
            "astro-ls"
          ];
          formatter = {
            command = "${nodePackages.prettier}/bin/prettier";
            args = [
              "--plugin"
              "prettier-plugin-astro"
            ];
          };
          auto-format = true;
        }
        {
          name = "typescript";
          language-servers = [
            "typescript-language-server"
            "eslint"
            "emmet-ls"
          ];
          formatter = {
            command = "${dprint}/bin/dprint";
            args = [
              "fmt"
              "--stdin"
              "typescript"
            ];
          };
          auto-format = true;
        }
        {
          name = "tsx";
          language-servers = [
            "typescript-language-server"
            "eslint"
            "emmet-ls"
          ];
          formatter = {
            command = "${dprint}/bin/dprint";
            args = [
              "fmt"
              "--stdin"
              "tsx"
            ];
          };
          auto-format = true;
        }
        {
          name = "javascript";
          language-servers = [
            "typescript-language-server"
            "eslint"
            "emmet-ls"
          ];
          formatter = {
            command = "${dprint}/bin/dprint";
            args = [
              "fmt"
              "--stdin"
              "javascript"
            ];
          };
          auto-format = true;
        }
        {
          name = "jsx";
          language-servers = [
            "typescript-language-server"
            "eslint"
            "emmet-ls"
          ];
          formatter = {
            command = "${dprint}/bin/dprint";
            args = [
              "fmt"
              "--stdin"
              "jsx"
            ];
          };
          auto-format = true;
        }
        {
          name = "json";
          formatter = {
            command = "${dprint}/bin/dprint";
            args = [
              "fmt"
              "--stdin"
              "json"
            ];
          };
          auto-format = true;
        }
        {
          name = "html";
          language-servers = [
            "vscode-html-language-server"
            "emmet-ls"
          ];
          formatter = {
            command = "${nodePackages.prettier}/bin/prettier";
            args = [
              "--parse"
              "html"
            ];
          };
          auto-format = true;
        }
        {
          name = "css";
          language-servers = [
            "vscode-html-language-server"
            "emmet-ls"
          ];
          formatter = {
            command = "${nodePackages.prettier}/bin/prettier";
            args = [
              "--parser"
              "css"
            ];
          };
          auto-format = true;
        }
      ];
    };
  };
}
