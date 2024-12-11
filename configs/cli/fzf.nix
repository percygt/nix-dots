{
  lib,
  config,
  pkgs,
  ...
}:
let
  c = config.modules.themes.colors.withHashtag;
in
{
  home.sessionVariables.FZF_DEFAULT_OPTS_FILE = pkgs.writeText "fzfrc" ''
    --cycle
    --pointer="▕"
    --marker="●"
    --separator="─"
    --prompt="  "
    --scrollbar="▌▐"
    --info=right
    --border-label-pos=0:bottom
    --border-label=" Result "
    --color=bg:-1,bg+:${c.base02}
    --color=fg:${c.base04},fg+:${c.base05}
    --color=hl:${c.base16},hl+:${c.base16}
    --color=border:${c.base04},gutter:${c.base00}
    --color=info:${c.base09},separator:${c.base04}
    --color=pointer:${c.base09},marker:${c.base09},prompt:${c.base09}
    --color=spinner:${c.base16}
  '';
  programs.fzf = {
    enable = true;
    tmux.enableShellIntegration = true;
    tmux.shellIntegrationOptions = [ "-p 50%,50%" ];
    defaultCommand = "${lib.getExe pkgs.fd} --type file --hidden --exclude .git";
    fileWidgetCommand = "${lib.getExe pkgs.ripgrep} --files --hidden -g !.git";
    changeDirWidgetCommand = "${lib.getExe pkgs.fd} --type directory --hidden --exclude .git";
  };
}
