{
  pkgs,
  config,
  lib,
  ...
}:
let
  g = config._base;
  inherit (g) flakeDirectory;
  c = config.modules.themes.colors.withHashtag;
  defaultShell = g.shell.defaultPackage;
  HISTORY_FILE = "${config.xdg.dataHome}/tmux/.session_history";
  saveSessionHistory = pkgs.writers.writeBash "saveSessionHistory" ''
    CURRENT_SESSION="$1"
    HISTORY_FILE="${HISTORY_FILE}"
    touch "$HISTORY_FILE"
    readarray -t sessions < "$HISTORY_FILE" 2>/dev/null || sessions=()
    if [[ "''${sessions[-1]}" == "$CURRENT_SESSION" ]]; then
      exit 0
    fi
    sessions+=("$CURRENT_SESSION")
    sessions=("''${sessions[@]: -2}")
    printf "%s\n" "''${sessions[@]}" > "$HISTORY_FILE"
  '';
  switchToPrev = pkgs.writers.writeBash "switchToPrev" ''
    HISTORY_FILE="${HISTORY_FILE}"
    touch "$HISTORY_FILE"
    readarray -t sessions < "$HISTORY_FILE" 2>/dev/null || sessions=()
    if [[ ''${#sessions[@]} -lt 2 ]]; then
      exit 0
    fi
    PREV_SESSION="''${sessions[0]}"
    tmux switch-client -t "$PREV_SESSION"
  '';
in
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    shell = lib.getExe defaultShell;
    keyMode = "vi";
    sensibleOnTop = true;
    aggressiveResize = true;
    mouse = true;
    customPaneNavigationAndResize = true;
    disableConfirmationPrompt = true;
    prefix = "C-a";
    escapeTime = 0;
    historyLimit = 1000000;
  };
  home = {
    # dependencies
    packages = with pkgs; [
      (writeShellApplication {
        name = "tmux-launch-session";
        runtimeInputs = [
          config.programs.tmux.package
        ];
        text = ''
          HISTORY_FILE="${HISTORY_FILE}"
          mkdir -p "$(dirname "$HISTORY_FILE")"
          touch "$HISTORY_FILE"
          readarray -t sessions < "$HISTORY_FILE" 2>/dev/null || sessions=()
          if tmux list-sessions &>/dev/null; then
            LAST_SESSION="''${sessions[1]:-}"
            if [[ -n "$LAST_SESSION" ]] && tmux has-session -t "$LAST_SESSION" 2>/dev/null; then
              tmux attach-session -t "$LAST_SESSION"
            else
              tmux attach-session
            fi
          else
            if [[ -d "$FLAKE" ]]; then
              SESSION="nix-dots"
              DIR="$FLAKE"
            else
              SESSION="home"
              DIR="$HOME"
            fi
            tmux new-session -As "$SESSION" -c "$DIR"
          fi
        '';
      })
      wl-clipboard
      moreutils
      fzf
      gitmux
    ];
  };
  xdg.configFile =
    let
      configTmux = "${flakeDirectory}/dev/tmux";
      symlink = file: config.lib.file.mkOutOfStoreSymlink file;
    in
    {
      "tmux/gitmux.yaml".source = symlink "${configTmux}/gitmux.yaml";
      "tmux/beforePlugins.conf".source = symlink "${configTmux}/beforePlugins.conf";
      "tmux/afterPlugins.conf".source = symlink "${configTmux}/afterPlugins.conf";
      "tmux/variables.conf".text = ''
        set -g @BORDER '${c.base02}'
        set -g @BORDER_ACTIVE '${c.base0A}'
        set -g @FG_PREFIX '${c.base16}'
        set -g @FG_PREFIX_ACTIVE '${c.base13}'
        set -g @FG_WINDOW_ACTIVE '${c.base06}'
        set -g @FG_WINDOW_PREV '${c.base08}'
        set -g @FG_STATUS '${c.base03}'
      '';
      "tmux/hooks.conf".text = ''
        set-hook -g client-session-changed 'run-shell "${saveSessionHistory} #{session_name}"'
      '';
      "tmux/binds.conf".text =
        #tmux
        ''
          # persistent `switchc -l`
          bind . run-shell "${switchToPrev}"
        '';
    };
}
