{
  flakeDirectory,
  inputs,
  username,
  lib,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  # wayland.windowManager.sway.extraOptions = ["--unsupported-gpu"];
  home.persistence."/persist/home/${username}" = {
    directories = [
      ".local/share/nix"
      ".local/share/atuin"
      ".local/share/nvim"
      ".local/share/fish"
      ".local/share/zoxide"
      ".config/BraveSoftware/Brave-Browser"
    ];
    files = [
      ".local/share/tmux/resurrect/last"
    ];
    allowOther = true;
  };
  home.sessionVariables.WLR_RENDERER = lib.mkForce "gles2";
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

  editor = {
    neovim.enable = true;
    # vscode.enable = true;
  };

  terminal = {
    wezterm.enable = true;
    foot.enable = true;
  };

  bin = {
    kpass.enable = true;
    pmenu.enable = true;
  };

  infosec = {
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
