{
  pkgs,
  config,
  lib,
  flakeDirectory,
  ...
}: {
  options.cli.tmux.home.enable = lib.mkEnableOption "Enable tmux";
  config = lib.mkIf config.cli.tmux.home.enable {
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
      inherit
        (import ./config.nix {
          inherit config;
          pkgs = pkgs.stash;
        })
        extraConfig
        ;
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
      activation = let
        moduleTmux = "${flakeDirectory}/modules/cli/tmux";
      in {
        linkTmux =
          lib.hm.dag.entryAfter ["linkGeneration"]
          ''
            [ -e "${config.xdg.configHome}/tmux" ] || mkdir -p "${config.xdg.configHome}/tmux"
            [ -e "${config.xdg.configHome}/tmux/gitmux.yaml" ] || ln -s ${moduleTmux}/gitmux.yaml ${config.xdg.configHome}/tmux/gitmux.yaml
            [ -e "${config.xdg.configHome}/tmux/beforePlugins.conf" ] || ln -s ${moduleTmux}/beforePlugins.conf ${config.xdg.configHome}/tmux/beforePlugins.conf
            [ -e "${config.xdg.configHome}/tmux/afterPlugins.conf" ] || ln -s ${moduleTmux}/afterPlugins.conf ${config.xdg.configHome}/tmux/afterPlugins.conf
          '';
      };
    };
    xdg.configFile = {
      "tmux/.tmux-env".text = ''
        TMUX_TMPDIR="${config.home.sessionVariables.TMUX_TMPDIR}"
      '';
    };
  };
}
