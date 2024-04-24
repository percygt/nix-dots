{
  inputs,
  username,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  browser.brave.enable = true;

  wayland.windowManager.sway.extraOptions = ["--unsupported-gpu"];

  # home.sessionVariables.WLR_RENDERER = lib.mkForce "gles2";

  home.persistence."/persist/home/${username}" = {
    directories = [
      ".local/share/nix"
      ".local/share/atuin"
      ".local/share/nvim"
      ".local/state/nvim"
      ".local/share/fish"
      ".local/share/zoxide"
      ".config/BraveSoftware/Brave-Browser"
      ".local/share/tmux/resurrect"
      ".cache/io.elementary.appcenter/"
      ".local/share/flatpak/"
      ".var/app/"
      ".codeium"
    ];
    allowOther = true;
  };

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

  bin = {
    kpass.enable = true;
    pmenu.enable = true;
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
