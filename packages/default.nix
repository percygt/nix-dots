{pkgs ? (import ../nixpkgs.nix) {}}: {
  lazysql = pkgs.callPackage ./go/lazysql.nix {};
}
