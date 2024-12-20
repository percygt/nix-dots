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
in
{
  imports = [ ./extraConfig.nix ];
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    shell = lib.getExe defaultShell;
    keyMode = "vi";
    sensibleOnTop = true;
    terminal = "tmux-256color";
    aggressiveResize = true;
    mouse = true;
    customPaneNavigationAndResize = true;
    disableConfirmationPrompt = true;
    prefix = "C-a";
    escapeTime = 0;
    historyLimit = 1000000;
  };
  home = {
    shellAliases.home = "tmux new -As home";
    # dependencies
    packages = with pkgs; [
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
      "tmux/beforePlugins.conf".source = config.lib.file.mkOutOfStoreSymlink "${moduleTmux}/beforePlugins.conf";
      "tmux/afterPlugins.conf".source = config.lib.file.mkOutOfStoreSymlink "${moduleTmux}/afterPlugins.conf";
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
