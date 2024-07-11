{
  pkgs,
  config,
  lib,
  flakeDirectory,
  ...
}: {
  options.cli.tmux.home.enable = lib.mkEnableOption "Enable tmux";
  config = lib.mkIf config.cli.tmux.home.enable {
    home = {
      shellAliases.home = "tmux new -As home";
      # dependencies
      packages = with pkgs; [
        wl-clipboard
        moreutils
        fzf
        gitmux
      ];

      activation = let
        moduleTmux = "${flakeDirectory}/modules/cli/tmux";
      in {
        linkTmux =
          lib.hm.dag.entryAfter ["linkGeneration"]
          ''
            [ -e "${config.xdg.configHome}/gitmux" ] || mkdir -p "${config.xdg.configHome}/gitmux"
            [ -e "${config.xdg.configHome}/gitmux/gitmux.yaml" ] || ln -s ${moduleTmux}/gitmux.yaml ${config.xdg.configHome}/gitmux/gitmux.yaml

            [ -e "${config.xdg.configHome}/tmux" ] || mkdir -p "${config.xdg.configHome}/tmux"
            [ -e "${config.xdg.configHome}/tmux/variables.tmux" ] || ln -s ${moduleTmux}/variables.tmux ${config.xdg.configHome}/tmux/variables.tmux
            [ -e "${config.xdg.configHome}/tmux/statusline.tmux" ] || ln -s ${moduleTmux}/statusline.tmux ${config.xdg.configHome}/tmux/statusline.tmux
            [ -e "${config.xdg.configHome}/tmux/keybinds.tmux" ] || ln -s ${moduleTmux}/keybinds.tmux ${config.xdg.configHome}/tmux/keybinds.tmux
          '';
      };
    };
    xdg.configFile = {
      "tmux/.tmux-env".text = ''
        TMUX_TMPDIR="${config.home.sessionVariables.TMUX_TMPDIR}"
      '';
    };

    programs.tmux = {
      enable = true;
      baseIndex = 1;
      shell = "${pkgs.fish}/bin/fish";
      keyMode = "vi";
      sensibleOnTop = false;
      terminal = "tmux-256color";
      aggressiveResize = true;
      mouse = true;
      customPaneNavigationAndResize = true;
      disableConfirmationPrompt = true;
      prefix = "C-a";
      escapeTime = 0;
      historyLimit = 1000000;
      extraConfig = ''
        source ${config.xdg.configHome}/tmux/keybinds.tmux
      '';
      inherit (import ./plugins.nix {inherit pkgs config;}) plugins;
      # inherit (import ./extra.nix {inherit pkgs;}) extraConfig;
    };
  };
}
