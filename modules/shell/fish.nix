{
  lib,
  config,
  pkgs,
  libx,
  ...
}: let
  inherit (libx) colors;
in {
  options = {
    shell.fish.enable = lib.mkOption {
      description = "Enable fish";
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.shell.fish.enable {
    programs = {
      fzf = {
        enable = true;
        colors = {
          "bg+" = "#${colors.extra.azure}";
          bg = "#${colors.normal.black}";
          preview-bg = "#${colors.default.background}";
        };
        tmux = {
          enableShellIntegration = true;
          shellIntegrationOptions = [
            "-p 100%,100%"
            "--preview-window=right,60%,,"
          ];
        };
        defaultCommand = "fd --type file --hidden --exclude .git";
        defaultOptions = [
          "--border rounded"
          "--info=inline"
        ];
        # CTRL-T - $FZF_CTRL_T_COMMAND
        fileWidgetCommand = "rg --files --hidden -g !.git";
        # ALT-C - $FZF_ALT_C_COMMAND
        changeDirWidgetCommand = "fd --type directory --hidden --exclude .git";
      };
      fish = {
        enable = true;
        plugins = with pkgs.fishPlugins; [
          {
            name = "fzf";
            inherit (fzf-fish) src;
          }
          {
            name = "bass";
            inherit (bass) src;
          }
        ];
        interactiveShellInit =
          /*
          fish
          */
          ''
            check_directory_for_new_repository


            set fish_greeting # Disable greeting

            bind \ee edit_command_buffer
            nix-your-shell fish | source

            bind \cr _fzf_search_history
            bind -M insert \cr _fzf_search_history

            bind \ct 'clear; commandline -f repaint'
            bind -M insert \ct 'clear; commandline -f repaint'

            fzf_configure_bindings --directory=\cf --variables=\ev --git_status=\cs --git_log=\cg
          '';
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
                ${pkgs.onefetch}/bin/onefetch
              end
              set -gx last_repository $current_repository
            '';
          };
        };
        shellInit =
          /*
          fish
          */
          ''
            # set GHQ_SELECTOR_OPTS --bind "alt-c:execute(code {} &> /dev/tty)"
            # bind --mode insert --sets-mode default jk repaint

            function starship_transient_rprompt_func
              starship module time
            end

            set -gx FZF_DEFAULT_OPTS "
              --border rounded
              --info=inline
              --bind=ctrl-j:down
              --bind=ctrl-k:up
              --bind=alt-j:preview-down
              --bind=alt-k:preview-up
              --preview-window=right,60%,,
              --color bg:#${colors.normal.black},bg+:#${colors.extra.azure},preview-bg:#${colors.default.background}"

            set -gx FZF_TMUX 1
            set -gx FZF_TMUX_OPTS "-p90%,75%"

            fish_vi_key_bindings
            set fish_cursor_default     block      blink
            set fish_cursor_insert      line       blink
            set fish_cursor_replace_one underscore blink
            set fish_cursor_visual      block
          '';
      };
    };
    xdg.configFile = {
      "fish/themes/base16.theme" = {
        onChange = "${pkgs.fish}/bin/fish -c 'echo y | fish_config theme save base16'";
        text =
          /*
          fish
          */
          ''
            fish_color_autosuggestion 808080
            fish_color_cancel --reverse
            fish_color_command yellow
            fish_color_comment red
            fish_color_cwd green
            fish_color_cwd_root red
            fish_color_end green
            fish_color_error brred
            fish_color_escape brcyan
            fish_color_history_current --bold
            fish_color_host normal
            fish_color_host_remote
            fish_color_keyword
            fish_color_normal normal
            fish_color_operator brcyan
            fish_color_option
            fish_color_param magenta
            fish_color_quote yellow
            fish_color_redirection 'cyan'  '--bold'
            fish_color_search_match 'bryellow'  '--background=brblack'
            fish_color_selection 'white'  '--bold'  '--background=brblack'
            fish_color_status red
            fish_color_user brgreen
            fish_color_valid_path --underline
            fish_pager_color_background
            fish_pager_color_completion normal
            fish_pager_color_description 'bryellow'  '--italics'
            fish_pager_color_prefix 'normal'  '--bold'  '--underline'
            fish_pager_color_progress 'brwhite'  '--background=cyan'
            fish_pager_color_secondary_background
            fish_pager_color_secondary_completion
            fish_pager_color_secondary_description
            fish_pager_color_secondary_prefix
            fish_pager_color_selected_background --reverse
            fish_pager_color_selected_completion
            fish_pager_color_selected_description
            fish_pager_color_selected_prefix
          '';
      };
    };
  };
}
