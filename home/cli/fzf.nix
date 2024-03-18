{ui, ...}: let
  inherit (ui) colors;
in {
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
          "-p 90%,75%"
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
      fileWidgetOptions = ["--preview 'preview {}'"];
      # ALT-C - $FZF_ALT_C_COMMAND
      changeDirWidgetCommand = "fd --type directory --hidden --exclude .git";
      changeDirWidgetOptions = ["--preview 'preview {}'"];
    };
  };
}
