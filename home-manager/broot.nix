{
  programs.broot = {
    enable = true;
    settings = {
      icon_theme = "vscode";
      default_flags = "-h";
      syntax_theme = "EightiesDark";
      quit_on_last_cancel = true;
      show_matching_characters_on_path_searches = false;
      modal = true;
      verbs = [
        {
          invocation = "code";
          shortcut = "c";
          key = "alt-c";
          apply_to = "text_file";
          execution = "code {file}";
          leave_broot = false;
        }
        {
          invocation = "tl {lines_count}";
          execution = "tail -f -n {lines_count} {file}";
        }
        {
          invocation = "touch {new_file}";
          execution = "touch {directory}/{new_file}";
          leave_broot = false;
        }
      ];
    };
  };
}
