{
  pkgs,
  lib,
  config,
  ...
}:
let
  g = config._global;
  fishShellPkg = pkgs.fish;
in
{
  programs = {
    zoxide.enableFishIntegration = true;
    fish = lib.mkMerge [
      {
        interactiveShellInit = lib.concatStringsSep "\n" (
          [
            # fish
            ''
              set fish_greeting # Disable greeting
              ${lib.getExe pkgs.nix-your-shell} fish | source
            ''
          ]
          ++ lib.optionals (g.shell.defaultPackage == fishShellPkg) [
            # fish
            ''
              bind \ev 'tv env'
              check_directory_for_new_repository
            ''
          ]
        );
      }
      (lib.mkIf (g.shell.defaultPackage == fishShellPkg) {
        functions = {
          envsource = ''
            for line in (cat $argv | grep -v '^#')
                set item (string split -m 1 '=' $line)
                set -gx $item[1] $item[2]
                echo "Exported key $item[1]"
            end
          '';
          cd = {
            body = ''
              builtin cd $argv || return
              check_directory_for_new_repository
            '';
            wraps = "cd";
          };

          check_directory_for_new_repository = {
            body = ''
              set current_repository (git rev-parse --show-toplevel 2> /dev/null)
              if [ "$current_repository" ] && \
                [ "$current_repository" != "$last_repository" ]
                ${lib.getExe pkgs.onefetch}
              end
              set -Ux last_repository $current_repository
            '';
          };
        };
      })
      {
        package = fishShellPkg;
        enable = true;
        shellInit = lib.concatStringsSep "\n" (
          # fish
          lib.optionals (g.shell.defaultPackage == fishShellPkg) [
            ''
              function fish_user_key_bindings
                  fish_default_key_bindings -M insert
                  fish_vi_key_bindings --no-erase insert
              end
            ''
          ]
          ++ lib.optionals (g.shell.defaultPackage == fishShellPkg) [
            ''
              function starship_transient_prompt_func
                 starship module character
              end

              # Change previous prompts right side
              function starship_transient_rprompt_func
                  echo -ne '\033[0;34m'(${pkgs.coreutils}/bin/date "+%I:%M:%S") '\033[0;32m<'
              end

              # ensure starship vars are set
              set -gx STARSHIP_CONFIG "${g.xdg.configHome}/starship.toml"
            ''
          ]
          ++ [
            ''
              set fish_cursor_default     block      blink
              set fish_cursor_insert      line       blink
              set fish_cursor_replace_one underscore blink
              set fish_cursor_visual      block
            ''
          ]
        );
      }
    ];
  };
  xdg.configFile = {
    "fish/themes/custom.theme" = {
      onChange = "${lib.getExe fishShellPkg} -c 'echo y | fish_config theme save custom'";
      text =
        # fish
        ''
          fish_color_normal normal
          fish_color_command blue
          fish_color_quote blue
          fish_color_redirection 'cyan' '--bold'
          fish_color_end green
          fish_color_error red
          fish_color_param magenta
          fish_color_comment red
          fish_color_match --background=brblue
          fish_color_cancel --reverse
          fish_color_cwd green
          fish_color_cwd_root red
          fish_color_escape cyan
          fish_color_history_current --bold
          fish_color_host normal
          fish_color_host_remote blue
          fish_color_keyword red
          fish_color_operator cyan
          fish_color_option cyan
          fish_color_search_match 'green' '--background=brblack'
          fish_color_selection 'white' '--bold' '--background=brblack'
          fish_color_status blue
          fish_color_user brgreen
          fish_color_autosuggestion cyan
          fish_color_valid_path 'blue' '--underline'
          fish_pager_color_background
          fish_pager_color_completion normal
          fish_pager_color_description 'yellow' '--italics'
          fish_pager_color_prefix 'green' '--bold' '--underline'
          fish_pager_color_progress
          fish_pager_color_secondary_background
          fish_pager_color_secondary_completion
          fish_pager_color_secondary_description
          fish_pager_color_secondary_prefix
          fish_pager_color_selected_background --background=brblack
          fish_pager_color_selected_completion
          fish_pager_color_selected_description
          fish_pager_color_selected_prefix
        '';
    };
  };
}
