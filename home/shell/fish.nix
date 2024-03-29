{pkgs, ...}: {
  programs.fish = {
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
      {
        name = "nix.fish";
        src = pkgs.fetchFromGitHub {
          owner = "kidonng";
          repo = "nix.fish";
          rev = "ad57d970841ae4a24521b5b1a68121cf385ba71e";
          sha256 = "13x3bfif906nszf4mgsqxfshnjcn6qm4qw1gv7nw89wi4cdp9i8q";
        };
      }
    ];
    interactiveShellInit =
      /*
      fish
      */
      ''
        export FZF_DEFAULT_OPTS="--border rounded --info=inline --preview-window=right,60%,, --color bg:#000000,bg+:#0e1a60,preview-bg:#00051A"
        export FZF_TMUX=1
        export FZF_TMUX_OPTS="-p90%,75%"

        set fish_greeting # Disable greeting
        check_directory_for_new_repository

        bind \ee edit_command_buffer
        nix-your-shell fish | source

        bind \cr _fzf_search_history
        bind -M insert \cr _fzf_search_history

        fzf_configure_bindings --directory=\cf --variables=\e\cv --git_status=\cs --git_log=\cg
      '';
    functions = {
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
    loginShellInit = ''
      check_directory_for_new_repository
    '';
    shellInit =
      /*
      fish
      */
      ''
        # set fzf_directory_opts --bind "ctrl-e:execute($EDITOR {} &> /dev/tty)" --bind "alt-c:execute(code {} &> /dev/tty)"
        set GHQ_SELECTOR_OPTS --bind "alt-c:execute(code {} &> /dev/tty)"

        function starship_transient_rprompt_func
          starship module time
        end
              
        fish_vi_key_bindings
        set fish_cursor_default     block      blink
        set fish_cursor_insert      line       blink
        set fish_cursor_replace_one underscore blink
        set fish_cursor_visual      block
        # bind --mode insert --sets-mode default jk repaint    '';
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
}
