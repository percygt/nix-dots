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
  defaultShell = g.shell.default.package;
  cfg = config.wayland.windowManager.sway.config;
  mod = cfg.modifier;
  foot-ddterm = pkgs.writers.writeBash "foot-ddterm" ''
    footclient --app-id='foot-ddterm' -- tmux-launch-session;
  '';

in
{
  imports = [ ./extraConfig.nix ];
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    shell = lib.getExe defaultShell;
    keyMode = "vi";
    sensibleOnTop = true;
    # terminal = "tmux-256color";
    aggressiveResize = true;
    mouse = true;
    customPaneNavigationAndResize = true;
    disableConfirmationPrompt = true;
    prefix = "C-a";
    escapeTime = 0;
    historyLimit = 1000000;
  };
  wayland.windowManager.sway.config.keybindings = lib.mkOptionDefault {
    "${mod}+w" = "exec ddapp -t 'foot-ddterm' -- ${foot-ddterm}";
  };
  home = {
    # dependencies
    packages = with pkgs; [
      (writeShellApplication {
        name = "tmux-launch-session";
        runtimeInputs = [
          pkgs.tmux
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
      moduleTmux = "${flakeDirectory}/configs/cli/tmux";
    in
    {
      "tmux/gitmux.yaml".source = config.lib.file.mkOutOfStoreSymlink "${moduleTmux}/gitmux.yaml";
      "tmux/beforePlugins.conf".source =
        config.lib.file.mkOutOfStoreSymlink "${moduleTmux}/beforePlugins.conf";
      "tmux/afterPlugins.conf".source =
        config.lib.file.mkOutOfStoreSymlink "${moduleTmux}/afterPlugins.conf";
      "tmux/.tmux-env".text = ''
        TMUX_TMPDIR="${config.home.sessionVariables.TMUX_TMPDIR}"
      '';
      "tmux/variables.conf".text = ''
        set -g @BORDER '${c.base02}'
        set -g @BORDER_ACTIVE '${c.base0A}'
        set -g @FG_PREFIX '${c.base14}'
        set -g @FG_PREFIX_ACTIVE '${c.base13}'
        set -g @FG_WINDOW_ACTIVE '${c.base16}'
        set -g @FG_WINDOW_PREV '${c.base08}'
        set -g @FG_STATUS '${c.base05}'
      '';
    };
}
