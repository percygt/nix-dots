{
  listImports,
  flakeDirectory,
  ...
}: let
  modules = [
    "."
    "_bin"
    "neovim"
    "shell"
    "terminal"
    "extra/vscodium.nix"
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
    listImports ../../home modules
    ++ [
      ./hyprland.nix
    ];
  home.shellAliases = {
    hms = "home-manager switch --flake ${flakeDirectory}'?submodules=1#'$hostname";
    ns = "sudo nixos-rebuild switch --flake ${flakeDirectory}'?submodules=1#'$hostname";
  };
}
