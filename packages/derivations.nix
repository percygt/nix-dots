{
  pkgs ? (import ./nixpkgs.nix) { },
}:
{
  lazysql = pkgs.callPackage ./go/lazysql.nix { };
  nerdfonts-fontconfig = pkgs.callPackage ./standard/nerdfonts-fontconfig.nix { };
  i3-quickterm = pkgs.python3Packages.callPackage ./python/i3-quickterm.nix { };
}
