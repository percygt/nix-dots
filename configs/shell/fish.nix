{
  pkgs,
  lib,
  config,
  ...
}:
let
  g = config._base;
  fishShellPkg = g.shell.fish.package;
in
{
  programs = {
    fish = lib.mkMerge [
      {
        interactiveShellInit = lib.concatStringsSep "\n" (
          [
            # fish
            ''
              set fish_greeting # Disable greeting
              ${lib.getExe pkgs.nix-your-shell} fish | source
              bind \cr _fzf_search_history
              bind -M insert \cr _fzf_search_history
              bind \ct 'clear; commandline -f repaint'
              bind -M insert \ct 'clear; commandline -f repaint'
              fzf_configure_bindings --directory=\cf --variables=\ev --git_status=\cs --git_log=\cg
            ''
          ]
          ++ lib.optionals (g.shell.default.package == fishShellPkg) [
            ''
              check_directory_for_new_repository
            ''
          ]
        );
      }
      (lib.mkIf (g.shell.default.package == fishShellPkg) {
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
              set -gx last_repository $current_repository
            '';
          };
        };
      })
      {
        package = fishShellPkg;
        enable = true;
        plugins = with pkgs.fishPlugins; [
          {
            name = "fzf";
            inherit (fzf-fish) src;
          }
        ];
        shellInit =
          # fish
          ''
            function starship_transient_prompt_func
               starship module character
            end

            # Change previous prompts right side
            function starship_transient_rprompt_func
              starship module time
            end

            set -gx STARSHIP_CONFIG "${config.xdg.configHome}/starship.toml"

            set -gx FZF_DEFAULT_OPTS "
              --border rounded
              --info=inline
              --bind=ctrl-j:down
              --bind=ctrl-k:up
              --bind=alt-j:preview-down
              --bind=alt-k:preview-up
              --preview-window=right,60%,,"

            set -gx FZF_TMUX 1
            set -gx FZF_TMUX_OPTS "-p90%,75%"

            fish_vi_key_bindings
            set fish_cursor_default     block      blink
            set fish_cursor_insert      line       blink
            set fish_cursor_replace_one underscore blink
            set fish_cursor_visual      block
          '';
        shellAliases = {
          ll = "${lib.getExe pkgs.eza} --group --header --group-directories-first --long --git --all --binary --icons";
          la = "ll -a";
          l = "${lib.getExe pkgs.eza} --group-directories-first --all -1";
          date-sortable = "date +%Y-%m-%dT%H:%M:%S%Z"; # ISO 8601 date format with local timezone
          date-sortable-utc = "date -u +%Y-%m-%dT%H:%M:%S%Z"; # ISO 8601 date format with UTC timezone
          tmp = "pushd $(mktemp -d)";
        };
      }
    ];
  };
  xdg.configFile = {
    "fish/themes/base16.theme" = {
      onChange = "${lib.getExe pkgs.fish} -c 'echo y | fish_config theme save base16'";
      text =
        # fish
        ''
          fish_color_autosuggestion 808080
          fish_color_normal white
          fish_color_command blue
          fish_color_param magenta
          fish_color_cancel --reverse
          fish_color_comment red
          fish_color_cwd green
          fish_color_cwd_root red
          fish_color_end green
          fish_color_error red
          fish_color_escape cyan
          fish_color_history_current --bold
          fish_color_host normal
          fish_color_host_remote blue
          fish_color_keyword red
          fish_color_operator cyan
          fish_color_option cyan
          fish_color_quote blue
          fish_color_redirection 'cyan' '--bold'
          fish_color_search_match 'green' '--background=brblack'
          fish_color_selection 'white' '--bold' '--background=brblack'
          fish_color_status blue
          fish_color_user green
          fish_color_valid_path 'blue' '--underline'
          fish_pager_color_background
          fish_pager_color_completion normal
          fish_pager_color_description 'yellow' '--italics'
          fish_pager_color_prefix 'green' '--bold' '--underline'
          fish_pager_color_progress 'brwhite' '--background=cyan'
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
}
