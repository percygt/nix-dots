{ lib, pkgs, ... }:
let
  fzfrc = pkgs.writeText "fzfrc" ''
    --color=fg:-1,fg+:#d0d0d0,bg:-1,bg+:#693838
    --color=hl:#5f87af,hl+:#5fd7ff,info:#afaf87,marker:#87ff00
    --color=prompt:#d7005f,spinner:#af5fff,pointer:#af5fff,header:#87afaf
    --color=border:#ababb7,label:#aeaeae,query:#d9d9d9
    --border="rounded" --border-label=" Result " --border-label-pos="0" --preview-window="border-rounded"
    --prompt="> " --marker=">" --pointer="◆" --separator="─"
    --scrollbar="▌▐" --layout="reverse" --info="right"'
  '';
in
{
  home.sessionVarables.FZF_DEFAULT_OPTS_FILE = fzfrc;
  programs.fzf = {
    enable = true;
    tmux = {
      enableShellIntegration = true;
      shellIntegrationOptions = [
        "-p 50%,50%"
        "--preview-window=right,60%,,"
      ];
    };
    defaultCommand = "${lib.getExe pkgs.fd} --type file --hidden --exclude .git";
    fileWidgetCommand = "${lib.getExe pkgs.ripgrep} --files --hidden -g !.git";
    changeDirWidgetCommand = "${lib.getExe pkgs.fd} --type directory --hidden --exclude .git";
  };
}
