{
  listHomeImports,
  config,
  pkgs,
  ...
}: let
  modules = [
    "."
    "_bin"
    "gnome"
    "shell"
    "terminal"
    "editor"
    "cli/starship.nix"
    "cli/atuin.nix"
    "cli/yazi.nix"
    "cli/direnv.nix"
    "cli/fzf.nix"
    "cli/extra.nix"
    "cli/tui.nix"
  ];
in {
  imports = listHomeImports modules;
  targets.genericLinux.enable = true;
  home = {
    packages = with pkgs; [
      gnomeExtensions.fedora-linux-update-indicator
      hwinfo
    ];
    shellAliases = {
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
  services.syncthing = {
    enable = true;
    extraOptions = [
      "-gui-address=fates.atlas-qilin.ts.net:8384"
    ];
  };
  xdg = {
    enable = true;
    mime.enable = true;
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
      		apply_properties = {},
      	},
      	{
      		matches = {
      			{
      				-- Matches all sources.
      				{ "node.name", "matches", "bluez_input.*" },
      			},
      			{
      				-- Matches all sinks.
      				{ "node.name", "matches", "bluez_output.*" },
      			},
      		},
      		apply_properties = {
      			["session.suspend-timeout-seconds"] = 0, -- 0 disables suspend
      		},
      	},
      }
    '';
  };

  dconf.settings = {
    "org/gnome/shell/extensions/fedora-update" = {
      update-cmd = "${pkgs.gnomeExtensions.ddterm}/share/gnome-shell/extensions/ddterm@amezin.github.com/bin/com.github.amezin.ddterm -- fish -c \"sudo dnf check-update --refresh & sudo dnf upgrade -y; echo Done - Press enter to exit; read _\" ";
      use-buildin-icons = false;
    };
  };
}
