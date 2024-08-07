{ config, pkgs, ... }:
let
  g = config._general;
in
{
  targets.genericLinux.enable = true;

  editor = {
    neovim.enable = true;
    vscode.enable = true;
    emacs.enable = true;
  };

  generic = {
    fonts.enable = true;
    bluez-suspend.disable = true;
    sops.enable = true;
    overlays.enable = true;
    xremap = {
      enable = true;
      withGnome = true;
    };
  };

  terminal = {
    wezterm.enable = true;
    foot.enable = true;
  };

  modules.security = {
    pass.enable = true;
    keepass.enable = true;
    backup.enable = true;
  };

  modules.cli = {
    atuin.enable = true;
    direnv.enable = true;
    extra.enable = true;
    starship.enable = true;
    tui.enable = true;
    yazi.enable = true;
  };
  home = {
    packages = with pkgs; [
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
      hms = "home-manager switch --flake ${g.flakeDirectory}#$hostname";
      hmr = "home-manager generations | fzf --tac | awk '{print $7}' | xargs -I{} bash {}/activate";
    };
    sessionVariables = {
      LIBVIRT_DEFAULT_URI = "qemu:///system";
      EDITOR = "nvim";
    };
  };
  services.syncthing = {
    enable = true;
    extraOptions = [ "-gui-address=fates.atlas-qilin.ts.net:8384" ];
  };
  xdg.systemDirs.data = [ "${g.homeDirectory}/.nix-profile/share/applications" ];
  dconf.settings = {
    "org/gnome/shell/extensions/fedora-update" = {
      update-cmd = "${pkgs.gnomeExtensions.ddterm}/share/gnome-shell/extensions/ddterm@amezin.github.com/bin/com.github.amezin.ddterm -- fish -c \"sudo dnf check-update --refresh & sudo dnf upgrade -y; echo Done - Press enter to exit; read _\" ";
      use-buildin-icons = false;
    };
  };
}
