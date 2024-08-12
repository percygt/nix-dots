{
  programs.fzf = {
    enable = true;
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
    fileWidgetCommand = "rg --files --hidden -g !.git";
    changeDirWidgetCommand = "fd --type directory --hidden --exclude .git";
  };
}
