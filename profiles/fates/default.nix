{
  config,
  pkgs,
  homeDirectory,
  ...
}:
let
  g = config._global;
in
{
  targets.genericLinux.enable = true;

  modules = {
    dev.enable = true;
    cli.enable = true;
    editor = {
      neovim.enable = true;
      # vscode.enable = true;
      # emacs.enable = true;
    };
  };

  home = {
    packages = with pkgs; [
      gnomeExtensions.fedora-linux-update-indicator
      hwinfo
    ];
    shellAliases = {
      mkVM = "qemu-system-x86_64 -enable-kvm -m 2G -boot menu=on -drive file=vm.img -cpu=host -vga virtio -display sdl,gl=on -cdrom";
      hms = "home-manager switch --flake ${g.flakeDirectory}#$hostname";
      hmr = "home-manager generations | fzf --tac | awk '{print $7}' | xargs -I{} bash {}/activate";
    };
  };
  services.syncthing = {
    enable = true;
    extraOptions = [ "-gui-address=fates.atlas-qilin.ts.net:8384" ];
  };
  xdg.systemDirs.data = [ "${homeDirectory}/.nix-profile/share/applications" ];
  dconf.settings = {
    "org/gnome/shell/extensions/fedora-update" = {
      update-cmd = "${pkgs.gnomeExtensions.ddterm}/share/gnome-shell/extensions/ddterm@amezin.github.com/bin/com.github.amezin.ddterm -- fish -c \"sudo dnf check-update --refresh & sudo dnf upgrade -y; echo Done - Press enter to exit; read _\" ";
      use-buildin-icons = false;
    };
  };
}
