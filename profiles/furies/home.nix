{
  config,
  pkgs,
  flakeDirectory,
  ...
}: {
  targets.genericLinux.enable = true;
  userModules = {
    git.enable = true;
    gpg.enable = true;
    ssh.enable = true;
  };
  desktop = {
    xdg = {
      enable = true;
      linkDirsToData.enable = true;
    };
    gtk.enable = true;
    qt.enable = true;
    gnome.enable = true;
  };

  editor = {
    neovim.enable = true;
    vscode.enable = true;
  };

  generic = {
    fonts.enable = true;
    xremap.enable = true;
    sops.enable = true;
  };

  terminal = {
    wezterm.enable = true;
    foot.enable = true;
  };

  bin = {
    kpass.enable = true;
    pmenu.enable = true;
  };

  security = {
    pass.enable = true;
    keepass.enable = true;
    backup.enable = true;
  };

  cli = {
    atuin.enable = true;
    direnv.enable = true;
    extra.enable = true;
    fzf.enable = true;
    starship.enable = true;
    tui.enable = true;
    yazi.enable = true;
  };

  home = {
    packages = with pkgs; [
      # gnomeExtensions.supergfxctl-gex
      gnomeExtensions.battery-health-charging
      gnomeExtensions.fedora-linux-update-indicator
      hwinfo
    ];
    activation.report-changes = config.lib.dag.entryAnywhere ''
      if [[ -n "$oldGenPath" && -n "$newGenPath" ]]; then
        ${pkgs.nvd}/bin/nvd diff $oldGenPath $newGenPath
      fi
    '';
    shellAliases = {
      mkVM = "qemu-system-x86_64 -enable-kvm -m 2G -boot menu=on -drive file=vm.img -cpu=host -vga virtio -display sdl,gl=on -cdrom";
      hms = "home-manager switch --flake ${flakeDirectory}#$HOSTNAME";
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
      "-gui-address=furies.atlas-qilin.ts.net:8384"
      "-home=${config.home.homeDirectory}/data/syncthing"
    ];
  };
  xdg = {
    systemDirs.data = ["${config.home.homeDirectory}/.nix-profile/share/applications"];
    configFile."wireplumber/50-bluez-config.lua".text = ''
      bluez_monitor.enabled = true

      bluez_monitor.properties = {
        ["with-logind"] = true,
      }

      bluez_monitor.rules = {
        {
          matches = {
            {
              { "device.name", "matches", "bluez_card.*" },
            },
          },
          apply_properties = {
          },
        },
        {
          matches = {
            {
              { "node.name", "matches", "bluez_input.*" },
            },
            {
              { "node.name", "matches", "bluez_output.*" },
            },
          },
          apply_properties = {
            ["session.suspend-timeout-seconds"] = 0,  -- 0 disables suspend
          },
        },
      }
    '';
  };
  dconf.settings = {
    "org/gnome/shell/extensions/fedora-update" = {
      # update-cmd = "${pkgs.gnomeExtensions.ddterm}/share/gnome-shell/extensions/ddterm@amezin.github.com/bin/com.github.amezin.ddterm -- ${pkgs.fish}/bin/fish -c \"sudo dnf check-update --refresh & sudo dnf upgrade -y; echo Done - Press enter to exit; read _\" ";
      use-buildin-icons = false;
    };
  };
}
