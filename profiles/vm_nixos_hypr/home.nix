{
  listImports,
  flakeDirectory,
  ...
}: let
  modules = [
    "_bin"
    # "neovim"
    "terminal/foot.nix"
    "shell"
    "extra/vscodium.nix"
    "cli/starship.nix"
    "cli/yazi.nix"
    "cli/direnv.nix"
    "cli/fzf.nix"
    # "cli/extra.nix"
    # "cli/tui.nix"
  ];
in {
  imports = listImports ../../home modules;
  home.shellAliases = {
    hms = "home-manager switch --flake ${flakeDirectory}'?submodules=1#'$hostname";
    ns = "sudo nixos-rebuild switch --flake ${flakeDirectory}'?submodules=1#'$hostname";
  };
}
