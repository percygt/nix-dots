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
          if [ -d "$FLAKE" ]; then
            tmux has-session -t nix-dots 2>/dev/null
            if [ ! $? ]; then
              tmux new-session -ds nix-dots -c "$FLAKE"
            fi
            tmux new-session -As nix-dots
          else
            tmux has-session -t home 2>/dev/null
            if [ ! $? ]; then
              tmux new-session -ds home -c "$HOME"
            fi
            tmux new-session -As home
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
    in
    {
      "tmux/gitmux.yaml".source = config.lib.file.mkOutOfStoreSymlink "${configTmux}/gitmux.yaml";
      "tmux/beforePlugins.conf".source =
        config.lib.file.mkOutOfStoreSymlink "${configTmux}/beforePlugins.conf";
      "tmux/afterPlugins.conf".source =
        config.lib.file.mkOutOfStoreSymlink "${configTmux}/afterPlugins.conf";
      "tmux/variables.conf".text = ''
        set -g @BORDER '${c.base02}'
        set -g @BORDER_ACTIVE '${c.base0A}'
        set -g @FG_PREFIX '${c.base14}'
        set -g @FG_PREFIX_ACTIVE '${c.base13}'
        set -g @FG_WINDOW_ACTIVE '${c.base06}'
        set -g @FG_WINDOW_PREV '${c.base08}'
        set -g @FG_STATUS '${c.base03}'
      '';
    };
}
