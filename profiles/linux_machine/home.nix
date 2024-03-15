{
  listImports,
  flakeDirectory,
  pkgs,
  ...
}: let
  modules = [
    "shell"
    "nix.nix"
    "fonts.nix"
    "cli/starship.nix"
    "cli/yazi.nix"
    "cli/direnv.nix"
  ];
in {
  imports = listImports ../../home modules;
  targets.genericLinux.enable = true;
  home.shellAliases = {
    hms = "home-manager switch --flake '${flakeDirectory}?submodules=1#generic_linux'";
  };
  dconf.settings = {
    "org/gnome/shell/extensions/fedora-update" = {
      update-cmd = "${pkgs.gnomeExtensions.ddterm}/share/gnome-shell/extensions/ddterm@amezin.github.com/bin/com.github.amezin.ddterm -- ${pkgs.fish}/bin/fish -c \"sudo dnf upgrade; echo Done - Press enter to exit; read _\" ";
      use-buildin-icons = false;
    };
  };
  home.packages = with pkgs; [
    gnomeExtensions.fedora-linux-update-indicator
  ];
}
