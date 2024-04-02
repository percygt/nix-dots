{
  lib,
  config,
  ui,
  ...
}: let
  inherit (ui) colors;
in {
  options = {
    cli.fzf.enable =
      lib.mkEnableOption "Enable fzf";
  };

  config = lib.mkIf config.cli.fzf.enable {
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
            "-p90%,75%"
          ];
        };
        defaultCommand = "fd --type file --hidden --exclude .git";
        defaultOptions = [
          "--border rounded"
          "--info=inline"
          "--preview-window=right,60%,,"
        ];
        # CTRL-T - $FZF_CTRL_T_COMMAND
        fileWidgetCommand = "rg --files --hidden -g !.git";
        fileWidgetOptions = ["--preview 'preview {}'"];
        # ALT-C - $FZF_ALT_C_COMMAND
        changeDirWidgetCommand = "fd --type directory --hidden --exclude .git";
        changeDirWidgetOptions = ["--preview 'preview {}'"];
      };
    };
  };
}
