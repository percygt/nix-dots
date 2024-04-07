{
  imports = [
    ./hyprland.nix
  ];
  # xdg.configFile = {
  #   "hypr/hyprland.conf".source = ./hyprland.conf;
  # };
  desktop = {
    xdg = {
      enable = true;
      linkDirsToData.enable = true;
    };
    gtk.enable = true;
    qt.enable = true;
  };

  editor = {
    # neovim.enable = true;
    # vscode.enable = true;
  };

  terminal = {
    # wezterm.enable = true;
    foot.enable = true;
  };

  # bin = {
  #   kpass.enable = true;
  #   pmenu.enable = true;
  # };
  #
  # security = {
  #   pass.enable = true;
  #   keepass.enable = true;
  #   backup.enable = true;
  # };

  # cli = {
  #   atuin.enable = true;
  #   direnv.enable = true;
  #   extra.enable = true;
  #   
  #   starship.enable = true;
  #   tui.enable = true;
  #   yazi.enable = true;
  # };
}
