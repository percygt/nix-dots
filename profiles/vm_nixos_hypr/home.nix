{
  flakeDirectory,
  listHomeImports,
  ...
}: let
  modules = [
    "."
    "_bin"
    # "neovim"
    "shell"
    "terminal"
    # "extra/vscodium.nix"
    "cli/starship.nix"
    "cli/yazi.nix"
    "cli/direnv.nix"
    "cli/fzf.nix"
    "cli/extra.nix"
    "cli/tui.nix"
    "desktop/hyprland"
  ];
in {
  imports =
    listHomeImports modules
    ++ [
      ./hyprland.nix
    ];
  home.shellAliases = {
    hms = "home-manager switch --flake ${flakeDirectory}#$hostname";
    ns = "sudo nixos-rebuild switch --flake ${flakeDirectory}#$hostname";
  };
}
