{pkgs ? (import ../nixpkgs.nix) {}}: {
  lazysql = pkgs.callPackage ./go/lazysql.nix {};
  martian-mono = pkgs.callPackage ./martian-mono.nix {};
}
