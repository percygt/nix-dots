{
  pkgs ? (import ./nixpkgs.nix) { },
}:
{
  lazysql = pkgs.callPackage ./go/lazysql.nix { };
  pomo = pkgs.callPackage ./standard/pomo.nix { };
  nerdfonts-fontconfig = pkgs.callPackage ./standard/nerdfonts-fontconfig.nix { };
  i3-quickterm = pkgs.python3Packages.callPackage ./python/i3-quickterm.nix { };
  colloid-gtk-theme-catppuccin = pkgs.callPackage ./standard/colloid-gtk-theme.nix { };
  colloid-kvantum = pkgs.callPackage ./standard/colloid-kvantum.nix { };
}
