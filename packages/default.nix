{pkgs ? (import ../nixpkgs.nix) {}}: {
  lazysql = pkgs.callPackage ./go/lazysql.nix {};
  martian-mono = pkgs.callPackage ./martian-mono.nix {};
  nodePackages-extra = pkgs.callPackage ./node {
    inherit pkgs;
    inherit (pkgs) system;
    nodejs = pkgs.nodejs_20;
  };
}
