{ lib, desktop, ... }:
{
  imports =
    [
      ./dev
      ./cli
      ./shell
      ./terminal
      ./rebuild
      ./utils
      ./nix.nix
      ./nixpkgs
    ]
    ++ lib.optionals (desktop != null) [
      ./apps
      ./desktop
      ./ui
    ];
}
