{
  pkgs ? (import ./nixpkgs.nix) { },
}:
{
  ## Brave nightly derivation source: https://github.com/kcalvelli/nixos/blob/ed0a9bd1b12513e9dd67fb822351f742595123c3/pkgs/brave-browser-nightly/make-brave-nightly.nix
  brave-nightly = pkgs.callPackage ./brave-nightly { };
  lazysql = pkgs.callPackage ./go/lazysql.nix { };
  pomo = pkgs.callPackage ./standard/pomo.nix { };
  nerdfonts-fontconfig = pkgs.callPackage ./standard/nerdfonts-fontconfig.nix { };
  i3-quickterm = pkgs.python3Packages.callPackage ./python/i3-quickterm.nix { };
  tui-network = pkgs.python3Packages.callPackage ./python/tui-network.nix { };
  colloid-gtk-theme-catppuccin = pkgs.callPackage ./standard/colloid-gtk-theme.nix { };
  colloid-kvantum = pkgs.callPackage ./standard/colloid-kvantum.nix { };
  straight-el = pkgs.callPackage ./standard/straight-el.nix { };
}
