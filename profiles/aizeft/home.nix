{
  desktop.apps = {
    firefox.enable = true;
    brave.enable = true;
  };

  wayland.windowManager.sway.extraOptions = ["--unsupported-gpu"];

  desktop = {
    modules = {
      xdg = {
        enable = true;
        linkDirsToData.enable = true;
      };
      gtk.enable = true;
      qt.enable = true;
    };
  };

  dev.git.ghq.enable = true;

  editor = {
    neovim.enable = true;
    vscode.enable = true;
  };

  terminal = {
    wezterm.enable = true;
    kitty.enable = true;
  };

  infosec = {
    common.enable = true;
    pass.enable = true;
    keepass.enable = true;
    backup.enable = true;
  };

  cli = {
    atuin.enable = true;
    direnv.enable = true;
    extra.enable = true;
    starship.enable = true;
    tui.enable = true;
    yazi.enable = true;
  };
}
