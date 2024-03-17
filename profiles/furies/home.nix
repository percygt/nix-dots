{
  listImports,
  config,
  pkgs,
  ...
}: let
  modules = [
    "."
    "_bin"
    "gnome"
    "neovim"
    "shell"
    "terminal"
    "extra/vscodium.nix"
    "extra/fonts.nix"
    "cli/starship.nix"
    "cli/yazi.nix"
    "cli/direnv.nix"
    "cli/fzf.nix"
    "cli/extra.nix"
    "cli/tui.nix"
  ];
in {
  imports = listImports ../../home modules;
  targets.genericLinux.enable = true;
  home = {
    packages = with pkgs; [
      gnomeExtensions.fedora-linux-update-indicator
      hwinfo
    ];
    shellAliases = {
      n2ne = "nvim $FLAKE_PATH/nixpkgs/node/packages.json";
      n2ni = "node2nix -i $FLAKE_PATH/nixpkgs/node/packages.json -e $FLAKE_PATH/nixpkgs/node/node-env.nix -o $FLAKE_PATH/nixpkgs/node/packages.nix -c $FLAKE_PATH/nixpkgs/node/default.nix";
      isobld = "nix build .'?submodules=1#'nixosConfigurations.iso.config.system.build.isoImage --impure";
      suisobld = "sudo nix build .'?submodules=1#'nixosConfigurations.dot_iso.config.system.build.isoImage";
      mkVM = "qemu-system-x86_64 -enable-kvm -m 2G -boot menu=on -drive file=vm.img -cpu=host -vga virtio -display sdl,gl=on -cdrom";
      stow_home = "stow -d /data/ -t $HOME stow_home/";
    };
    sessionVariables = {
      LIBVIRT_DEFAULT_URI = "qemu:///system";
      EDITOR = "nvim";
    };
  };
  xdg = {
    enable = true;
    mime.enable = true;
    systemDirs.data = ["${config.home.homeDirectory}/.nix-profile/share/applications"];
    configFile.wireplumber = {
      source = ../../home/_config/wireplumber;
      recursive = true;
    };
  };

  dconf.settings = {
    "org/gnome/shell/extensions/fedora-update" = {
      update-cmd = "${pkgs.gnomeExtensions.ddterm}/share/gnome-shell/extensions/ddterm@amezin.github.com/bin/com.github.amezin.ddterm -- fish -c \"sudo dnf check-update --refresh & sudo dnf upgrade -y; echo Done - Press enter to exit; read _\" ";
      use-buildin-icons = false;
    };
  };
}
