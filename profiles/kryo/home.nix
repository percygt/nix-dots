{
  pkgs,
  config,
  profile,
  flakeDirectory,
  ...
}: {
  desktop = {
    modules = {
      xdg = {
        enable = true;
        linkDirsToData.enable = true;
      };
      gtk.enable = true;
      qt.enable = true;
    };
    gnome.enable = true;
  };

  editor = {
    neovim.enable = true;
    vscode.enable = true;
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
  home = {
    packages = with pkgs; [
      gnomeExtensions.battery-health-charging
      hwinfo
    ];
    activation.report-changes = config.lib.dag.entryAnywhere ''
      if [[ -n "$oldGenPath" && -n "$newGenPath" ]]; then
        ${pkgs.nvd}/bin/nvd diff $oldGenPath $newGenPath
      fi
    '';
    shellAliases = {
      hms = "home-manager switch --flake ${flakeDirectory}#$hostname";
      hmr = "home-manager generations | fzf --tac | awk '{print $7}' | xargs -I{} bash {}/activate";
    };
    sessionVariables = {
      LIBVIRT_DEFAULT_URI = "qemu:///system";
      EDITOR = "nvim";
    };
  };
  services.syncthing = {
    enable = true;
    extraOptions = [
      "-gui-address=${profile}.atlas-qilin.ts.net:8384"
      "-home=${config.home.homeDirectory}/data/syncthing"
    ];
  };
}
