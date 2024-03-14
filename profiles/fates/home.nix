{
  listImports,
  flakeDirectory,
  config,
  pkgs,
  ...
}: let
  modules = [
    "_bin"
    "gnome"
    "neovim"
    "shell"
    "terminal"
    "nix.nix"
    "fonts.nix"
    "tmux.nix"
    "vscodium.nix"
    "starship.nix"
    "yazi.nix"
    "direnv.nix"
    "cli.nix"
    "nixtools.nix"
    "zathura.nix"
  ];
in {
  imports = listImports ../../home modules;
  targets.genericLinux.enable = true;
  home.shellAliases = {
    hms = "home-manager switch --flake ${flakeDirectory}'?submodules=1#'$hostname";
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
  home.packages = with pkgs; [
    gnomeExtensions.fedora-linux-update-indicator
    nautilus-open-any-terminal
    gnome.gnome-tweaks
  ];
}
