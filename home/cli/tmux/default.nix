{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    cli.tmux.enable =
      lib.mkEnableOption "Enable tmux";
  };

  imports = [
    ./gitmux.nix
    ./resurrect-post-save.nix
  ];

  config = lib.mkIf config.cli.tmux.enable {
    # dependencies
    home.packages = with pkgs; [
      wl-clipboard
      moreutils
      fzf
    ];

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
      sensibleOnTop = true;
      terminal = "tmux-256color";
      mouse = true;
      customPaneNavigationAndResize = true;
      disableConfirmationPrompt = true;
      prefix = "C-a";
      escapeTime = 0;
      historyLimit = 1000000;
      inherit (import ./plugins.nix {inherit pkgs config;}) plugins;
      inherit (import ./extra.nix) extraConfig;
    };
  };
}
