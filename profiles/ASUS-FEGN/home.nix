{
  listImports,
  flakeDirectory,
  config,
  pkgs,
  ...
}: let
  modules = [
    "gnome"
    "neovim"
    "shell"
    "terminal"
    "scripts"
    "nix.nix"
    "fonts.nix"
    "tmux.nix"
    "vscodium.nix"
    "zellij.nix"
    "starship.nix"
    "yazi.nix"
    "broot.nix"
    "direnv.nix"
    "fastfetch.nix"
    "cli.nix"
    "nixtools.nix"
    "zathura.nix"
  ];
  quake-mode = pkgs.callPackage ../../packages/gnome/extensions/quake-mode.nix {};
  date-menu-formatter = pkgs.callPackage ../../packages/gnome/extensions/date-menu-formatter.nix {};
in {
  imports = listImports ../../home modules;

  targets.genericLinux.enable = true;

  home.shellAliases = {
    hms = "home-manager switch --flake ${flakeDirectory}'?submodules=1#'home@$hostname";
  };

  xdg = {
    mime.enable = true;
    systemDirs.data = ["${config.home.homeDirectory}/.nix-profile/share/applications"];
    configFile.wireplumber = {
      source = ../../home/_config/wireplumber;
      recursive = true;
    };
  };

  dconf.settings = {
    "org/gnome/shell/extensions/fedora-update" = {
      update-cmd = "${pkgs.gnomeExtensions.ddterm}/share/gnome-shell/extensions/ddterm@amezin.github.com/bin/com.github.amezin.ddterm -- ${pkgs.fish}/bin/fish -c \"sudo dnf upgrade; echo Done - Press enter to exit; read _\" ";
      use-buildin-icons = false;
    };
  };
  
  # programs.gnome-terminal.enable = true;
  home.packages = with pkgs;
    [
      gnome.gnome-tweaks
      gnome.dconf-editor
      gnome-extension-manager
      gnomeExtensions.supergfxctl-gex
      gnomeExtensions.space-bar
      gnomeExtensions.user-themes
      gnomeExtensions.appindicator
      gnomeExtensions.dash-to-panel
      gnomeExtensions.appindicator
      gnomeExtensions.pop-shell
      gnomeExtensions.caffeine
      gnomeExtensions.vertical-workspaces
      gnomeExtensions.dash-to-panel
      gnomeExtensions.battery-health-charging
      gnomeExtensions.ddterm
      gnomeExtensions.bluetooth-quick-connect
      gnomeExtensions.docker
      gnomeExtensions.mpris-label
      gnomeExtensions.reboottouefi
      gnomeExtensions.shutdowntimer
      gnomeExtensions.trimmer
      gnomeExtensions.systemstatsplus
      gnomeExtensions.disable-unredirect-fullscreen-windows
      gnomeExtensions.quick-settings-tweaker
      gnomeExtensions.fedora-linux-update-indicator
    ]
    ++ [
      quake-mode
      date-menu-formatter
    ];
}
