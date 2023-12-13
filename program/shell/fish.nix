{pkgs, ...}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    loginShellInit = ''
      ${pkgs.fastfetch}/bin/fastfetch
    '';
    plugins = with pkgs.fishPlugins; [
      {
        name = "z";
        src = z.src;
      }
      {
        name = "fzf";
        src = fzf-fish.src;
      }
      {
        name = "bass";
        src = bass.src;
      }
      {
        name = "grc";
        src = grc.src;
      }
      {
        name = "sponge";
        src = sponge.src;
      }
      {
        name = "forgit";
        src = forgit.src;
      }
      {
        name = "autopair";
        src = autopair.src;
      }
      {
        name = "preview";
        src = pkgs.fetchFromGitHub {
          owner = "percygt";
          repo = "preview.fish";
          rev = "ba3fbef3a9f23840b25764be2e1c82da5b205d42";
          hash = "sha256-dxG9Drbmy0M5c4lCzeJ4k7BnkrJwmpI4IpkeRP6CYFk=";
        };
      }
      {
        name = "fish-ghq";
        src = pkgs.fetchFromGitHub {
          owner = "percygt";
          repo = "fish-ghq";
          rev = "cafaaabe63c124bf0714f89ec715cfe9ece87fa2";
          hash = "sha256-6b1zmjtemNLNPx4qsXtm27AbtjwIZWkzJAo21/aVZzM=";
        };
      }
    ];
    shellInit = ''
      set fzf_preview_file_cmd preview
      set fzf_configure_bindings --variables=\e\cv
      set fzf_fd_opts --hidden --exclude=.git
      set fzf_directory_opts --bind "ctrl-e:execute($EDITOR {} &> /dev/tty)" --bind "alt-c:execute(code {} &> /dev/tty)"
      set GHQ_SELECTOR_OPTS --bind "alt-c:execute(code {} &> /dev/tty)"

      #starship retain module character in transient prompt
      function starship_transient_prompt_func
        starship module character
      end

      function fish_user_key_bindings
          # Execute this once per mode that emacs bindings should be used in
          fish_default_key_bindings -M insert

          # Then execute the vi-bindings so they take precedence when there's a conflict.
          # Without --no-erase fish_vi_key_bindings will default to
          # resetting all bindings.
          # The argument specifies the initial mode (insert, "default" or visual).
          fish_vi_key_bindings --no-erase insert


      end
      bind yy fish_clipboard_copy
      bind Y fish_clipboard_copy
      bind p fish_clipboard_paste
      # Emulates vim's cursor shape behavior
      # Set the normal and visual mode cursors to a block
      set fish_cursor_default block
      # Set the insert mode cursor to a line
      set fish_cursor_insert line
      # Set the replace mode cursor to an underscore
      set fish_cursor_replace_one underscore
      # The following variable can be used to configure cursor shape in
      # visual mode, but due to fish_cursor_default, is redundant here
      set fish_cursor_visual block
    '';
    functions = {
      _preview_mime_image = {
        body = ''
          if [ -n "$TERM_PROGRAM" ] && [ "$TERM_PROGRAM" = "WezTerm" ]
              timg -g (math $COLUMNS - 10)x$LINES -p k --frames 1 $argv
          else
              timg -g (math $COLUMNS - 2)x$LINES --frames 1 $argv
          end
        '';
      };
    };
  };
  xdg.configFile = {
    "fish/themes/base16.theme" = {
      onChange = "${pkgs.fish}/bin/fish -c 'echo y | fish_config theme save base16'";
      text = ''
        fish_color_autosuggestion 808080
        fish_color_cancel --reverse
        fish_color_command d7ff00
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
        fish_color_param d787ff
        fish_color_quote yellow
        fish_color_redirection 'cyan'  '--bold'
        fish_color_search_match 'bryellow'  '--background=brblack'
        fish_color_selection 'white'  '--bold'  '--background=brblack'
        fish_color_status red
        fish_color_user brgreen
        fish_color_valid_path --underline
        fish_pager_color_background
        fish_pager_color_completion normal
        fish_pager_color_description 'B3A06D'  '--italics'
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
